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
                        -
                          en: cat
                          ja:
                            ja: 猫
                            en: cats?
                        -
                          ja:
                            ja: 。
                            en: !ruby/regexp /\\.\\s?/
                        -
                          en: mouth
                          es: boca
                        -
                          es: mano
                          ja: 手
                        -
                          en:
                            en: book
                            ja: 本
                        -
                          en: North Carolina
                          ja: ノースカロライナ
                      eos
    @dictionary.rewind
  end

  describe "when converting from English to Japanese" do
    before :each do
      Dictionary.load "en", "ja", { :using => [@dictionary.path] }
    end

    it "should correctly load a simple term" do
      Dictionary.pairs.first.should == [/\bdogs\b/i, "犬"]
    end

    it "should correctly load a slightly more complex regular expression" do
      Dictionary.pairs[1].should == [/\bcats?\b/i, "猫"]
    end

    it "should correctly load a manual regular expression" do
      Dictionary.pairs[2].should == [/\.\s?/, "。"]
    end

    it "should ignore examples for which the source language cannot be found" do
      Dictionary.pairs.keep_if { |t| t[0] == /\bmano\b/i }.empty?.should == true
    end

    it "should ignore examples for which the target language cannot be found" do
      Dictionary.pairs.keep_if { |t| t[1] == "book" }.empty?.should == true
    end

    it "should only have a case-insensitive search if the search contains capital letters" do
      Dictionary.pairs[0][0].should == /\bdogs\b/i
      Dictionary.pairs[3][0].should == /\bNorth Carolina\b/
    end
  end

  describe "when converting from Japanese to English" do
    before :each do
      Dictionary.load "ja", "en", { :using => [@dictionary.path] }
    end

    it "should add whitespace to term replacement" do
      Dictionary.pairs.first.should == [/犬/i, "dogs "]
    end
  end

  describe "when converting from English to Spanish" do
    before :each do
      Dictionary.load "en", "es", { :using => [@dictionary.path] }
    end

    it "should not add whitespace to term replacement" do
      Dictionary.pairs[0].should == [/\bmouth\b/i, "boca"]
    end
  end
end
