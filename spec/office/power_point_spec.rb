# coding: utf-8
describe "PowerPoint", :power_point do
  describe "opening the sample document" do
    before :all do
      @export_target = StringIO.new <<-eof
--- /Users/bryan/Projects/konjac/spec/office/bin/sample.pptx
+++ /Users/bryan/Projects/konjac/spec/office/bin/sample.pptx
@@ 1,1 @@
-Title
+Title
@@ 1,2 @@
-Subtitle
+Subtitle
@@ 2,1 @@
-Page title
+Page title
@@ 2,2 @@
-Bullet point 1
-Bullet point 2with a line break
-Bullet point 3
-Indented bullet point
+Bullet point 1
+Bullet point 2with a line break
+Bullet point 3
+Indented bullet point
@@ 2,3 @@
-Text box
+Text box
      eof
      @spec_path = File.dirname(File.expand_path(__FILE__))
      @path = File.join(@spec_path, "bin", "sample.pptx")
      @diff_path = "#{@path}.diff"
      @deck = Office.power_point(@path)
      @original_size = @deck.size
    end

    after :all do
      @deck.close :saving => false
    end

    it "should open the test document" do
      @deck.should_not be_nil
    end

    it "should return the same path" do
      @deck.path.should == @path
    end

    it "should export tags to a tags file" do
      File.delete @diff_path rescue Errno::ENOENT
      @deck.export
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
      @deck.read(1, 2).should == ["Subtitle"]
      @deck.read(2, 2).should == ["Bullet point 1", "Bullet point 2\vwith a line break", "Bullet point 3", "Indented bullet point"]
      @deck.read(2, 3).should == ["Text box"]
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
      @deck.import
      @deck.data.each do |tag|
        tag.added.each do |tag_part|
          tag_part.should == lines.shift
        end
      end
    end

    it "should not have any change in size" do
      @deck.size.should == @original_size
    end
  end
end
