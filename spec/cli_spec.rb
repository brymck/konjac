# coding: utf-8
require "tempfile"

describe CLI do
  # Super hacky way of setting a constant without setting off a warnings that the
  # constant has already been initialized
  def set_argv(*params)
    Object.__send__ :remove_const, :ARGV
    Object.const_set :ARGV, params
  end

  it "should fail on an invalid subcommand" do
    set_argv "invalid", "--quiet"
    lambda { CLI.start }.should raise_error SystemExit
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

      @converted = Utils.build_converted_file_name(@english.path, "en", "ja")

      # Set ARGV
      set_argv "translate", "-t", "japanese", "-u", @dictionary.path,
        @english.path, "-y", "-o", @converted
    end

    it "should correctly translate English text" do
      CLI.start
      File.read(@english.path).should == "I like dogs."
      File.open(@converted, "r") do |file|
        file.each do |line|
          line.chomp.should == "I like 犬."
        end
      end
    end
  end
end
