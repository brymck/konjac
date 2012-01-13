# coding: utf-8
require File.dirname(__FILE__) + "/spec_helper"
require "tempfile"

describe CLI do
  # Super hacky way of setting a constant without setting off a warnings that the
  # constant has already been initialized
  def set_argv(*params)
    Object.__send__ :remove_const, :ARGV
    Object.const_set :ARGV, params
  end

  it "should fail on an invalid subcommand" do
    set_argv "invalid"
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

      # Set ARGV
      set_argv "translate", @english.path, "into", "japanese", "using",
        @dictionary.path
    end

    it "should correctly translate English text" do
      begin
        CLI.start
        converted_path = Utils.build_converted_file_name(@english.path, "en", "ja")
        File.read(@english.path).should == "I like dogs."
        File.read(converted_path).should == "I like 犬.\n"
      ensure
        @dictionary.close!
        @english.close!
        File.delete converted_path
      end
    end

    it "should return the name of the sub_command" do
      CLI.start.should == :translate
    end
  end
end
