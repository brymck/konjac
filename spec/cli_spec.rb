# coding: utf-8
require File.dirname(__FILE__) + "/spec_helper"
require "tempfile"

describe CLI do
  it "should fail on an invalid subcommand" do
    ARGV = ["invalid"]
    lambda { CLI.start }.should raise_error InvalidCommandError
  end

  describe "temporary files" do
    before :each do
      # Create dictionary
      @dictionary = Tempfile.new(["dict", ".yml"])
      @dictionary.write <<-eos
                          -
                           en: dogs
                           ja: 犬
                        eos
      @dictionary.rewind

      # Create English text to translate
      @english = Tempfile.new(["english", "_en.txt"])
      @english.write "I like dogs."
      @english.rewind
    end

    it "should correctly translate English text" do
      begin
        ARGV = ["translate", @english.path, "into", "japanese", "using", @dictionary.path]
        CLI.start
        converted_path = Utils.build_converted_file_name(@english.path, "en", "ja")
        puts File.read(@english.path).should == "I like dogs."
        File.read(converted_path).should == "I like 犬.\n"
      ensure
        @dictionary.close!
        @english.close!
        File.delete converted_path
      end
    end
  end
end
