# coding: utf-8
require File.dirname(__FILE__) + "/../spec_helper"

describe "Word", :word do
  describe "opening the sample document" do
    before :all do
      @export_target = StringIO.new <<-eof
--- /Users/bryan/Projects/konjac/spec/office/bin/sample.docx
+++ /Users/bryan/Projects/konjac/spec/office/bin/sample.docx
@@ 1 @@
-Normal paragraph
+Normal paragraph
@@ 2 @@
-Paragraph with a
-line break
+Paragraph with a
+line break
@@ 3 @@
-	Tabbed paragraph
+	Tabbed paragraph
@@ 4 @@
-Bullet point 1
+Bullet point 1
@@ 5 @@
-Bullet point 2
+Bullet point 2
@@ 6 @@
-Bullet point 3
+Bullet point 3
@@ 7 @@
-Header 1
+Header 1
@@ 8 @@
-Header 2
+Header 2
@@ 9 @@
-Header 3
+Header 3
@@ 11 @@
-Cell 1
+Cell 1
@@ 12 @@
-Cell 2
+Cell 2
@@ 13 @@
-Cell 3
+Cell 3
@@ 15 @@
-Cell 4
+Cell 4
@@ 16 @@
-Cell 5
+Cell 5
@@ 17 @@
-Cell 6
+Cell 6
@@ shape 1 @@
-Text box
+Text box
      eof
      @spec_path = File.dirname(File.expand_path(__FILE__))
      @path = File.join(@spec_path, "bin", "sample.docx")
      @diff_path = "#{@path}.diff"
      @doc = Office.word(@path)
      @original_size = @doc.size
    end

    after :all do
      @doc.close :saving => false
    end

    it "should open the test document" do
      @doc.read.should == ["Normal paragraph"]
    end

    it "should return the same path" do
      @doc.path.should == @path
    end

    it "should export tags to a tags file" do
      File.delete @diff_path rescue Errno::ENOENT
      @doc.export
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
      @doc.read(3).should == ["\tTabbed paragraph"]
      @doc.read(6).should == ["Bullet point 3"]
      @doc.read(13).should == ["Cell 3"]
      @doc.read(1, :type => :shape).should == ["Text box"]
    end

    it "should import all tags correctly" do
      @export_target.rewind
      @doc.find 1
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
      @doc.import
      @doc.data.each do |tag|
        tag.added.each do |tag_part|
          tag_part.should == lines.shift
        end
      end
    end

    it "should not have any change in size" do
      @doc.size.should == @original_size
    end
  end
end
