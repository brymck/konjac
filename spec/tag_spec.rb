# coding: utf-8
require File.dirname(__FILE__) + "/spec_helper"
require "tempfile"

describe Tag do
  before :each do
    @tags_file = Tempfile.new(["tags", ".tags"])
    @tags_file.write <<-eos.gsub(/^\s+/, "")
                       [[KJ-1]]
                       > 犬
                       dog
                       [[KJ-2]]
                       > 何ですか。
                       What is it?
                       [[KJ-3]]
                       > 空白
                       [[KJ-6]]
                       > 以上
                       -- end --
                     eos
    @tags_file.rewind
    @manager = TagManager.new(@tags_file.path)
  end

  it "should accurately read a tag file" do
    @manager.all.should_not == nil
    @manager[0].index.should == 1
    @manager[0].original.should == "犬"
    @manager[0].translated.should == "dog"
  end

  it "should succeed reading multiple lines" do
    @manager[1].index.should == 2
    @manager[1].original.should == "何ですか。"
    @manager[1].translated.should == "What is it?"
  end

  it "should ignore blank translations" do
    @manager[2].index.should == 3
    @manager[2].original.should == "空白"
    @manager[2].translated.should == nil
  end

  it "should skip over blank indexes" do
    @manager[3].index.should == 6
  end
end
