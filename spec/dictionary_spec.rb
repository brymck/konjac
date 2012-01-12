# coding: utf-8
require File.dirname(__FILE__) + "/spec_helper"
require "tempfile"

describe Dictionary do
  before :each do
    @dictionary = Tempfile.new(["dict", ".yml"])
    @dictionary.write <<-eos
                        -
                         en: dogs
                         ja: 犬
                      eos
    @dictionary.rewind
  end

  it "should correctly load YAML" do
    Dictionary.load "en", "ja", [@dictionary.path]
    Dictionary.pairs.should == [[/\bdogs\b/, "犬"]]
  end
end
