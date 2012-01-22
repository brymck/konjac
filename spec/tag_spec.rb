# coding: utf-8
require File.dirname(__FILE__) + "/spec_helper"
require "tempfile"

describe Tag do
  before :each do
    @tags_file = Tempfile.new(["tags", ".tags"])
    @tags_file.write <<-eos.gsub(/^\s+/, "")
                       --- /path/to/old
                       +++ /path/to/new
                       @@ 0 @@
                       -犬
                       +dog
                       @@ 1 @@
                       -何ですか。
                       +What is it?
                       @@ 2 @@
                       -空白
                       @@ 3 comment @@
                       -コメント
                       +Comment
                       @@ 5 @@
                       -以上
                       +--- end --
                     eos
    @tags_file.rewind
    @manager = TagManager.new(@tags_file.path)
  end

  it "should accurately read a tag" do
    @manager.all.should_not == nil
    @manager[0].index.should == 0
    @manager[0].original.should == "犬"
    @manager[0].translated.should == "dog"
  end

  it "should succeed reading multiple tags" do
    @manager[1].index.should == 1
    @manager[1].original.should == "何ですか。"
    @manager[1].translated.should == "What is it?"
  end

  it "should ignore blank translations" do
    @manager[2].index.should == 2
    @manager[2].original.should == "空白"
    @manager[2].translated.should == nil
  end

  it "should know whether a tag has been translated" do
    @manager[0].translated?.should == true
    @manager[2].translated?.should == false
  end

  it "should ignore comments and additional info after an index tag" do
    @manager[3].index.should == 3
    @manager[3].original.should == "コメント"
    @manager[3].translated.should == "Comment"
  end

  it "should skip over blank indexes" do
    @manager[4].index.should == 5
  end
end
