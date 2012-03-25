# coding: utf-8
describe "Excel", :excel do
  describe "opening the sample document" do
    before :all do
      @export_target = StringIO.new <<-eof
--- /Users/bryan/Projects/konjac/spec/office/bin/sample.xlsx
+++ /Users/bryan/Projects/konjac/spec/office/bin/sample.xlsx
@@ 1,1,1 @@
-=UPPER("Formula")
+=UPPER("Formula")
@@ 1,2,4 @@
-32768
+32768
@@ 1,3,2 @@
-No formula
+No formula
@@ 1,5,1 @@
-Cell with
-a line break
+Cell with
+a line break
@@ shape 1,1 @@
-Text box
-with soft return
+Text box
+with soft return
@@ 2,4,3 @@
-New sheet
+New sheet
      eof
      @spec_path = File.dirname(File.expand_path(__FILE__))
      @path = File.join(@spec_path, "bin", "sample.xlsx")
      @diff_path = "#{@path}.diff"
      @book = Office.excel(@path)
      @original_size = @book.size
    end

    after :all do
      @book.close :saving => false
    end

    it "should open the test document" do
      @book.should_not be_nil
    end

    it "should return the same path" do
      @book.path.should == @path
    end

    it "should export tags to a tags file" do
      File.delete @diff_path rescue Errno::ENOENT
      @book.export
      File.exists?(@diff_path).should == true
    end

    it "should have exported the expected tags" do
      @export_target.rewind
      tags = File.open(@diff_path)
      tags.each_line do |tag|
        tag.should == @export_target.readline
      end
    end

    it "should read some arbitrary items correctly" do
      @book.read(1, 3, 2).should == ["No formula"]
      @book.read(1, 5, 1).should == ["Cell with", "a line break"]
      @book.read(1, 2, 4).should == ["32768"]
      @book.read(1, 1, :type => :shape).should == ["Text box", "with soft return"]
    end

    it "should import all tags correctly" do
      @export_target.rewind
      index = 0
      lines = []
      File.open(@diff_path, "w") do |file|
        @export_target.each do |line|
          if line =~ /^\+/ && line !~ /^\+\+\+/
            line = "#{line.chomp} - #{index}"
            lines << line[1..-1]
            index += 1
          end

          file.puts line
        end
      end
      @book.import
      @book.data.each do |tag|
        tag.added.each do |tag_part|
          tag_part.should == lines.shift
        end
      end
    end

    it "should not have any change in size" do
      @book.size.should == @original_size
    end
  end
end
