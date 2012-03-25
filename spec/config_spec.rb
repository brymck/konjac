# coding: utf-8
require "tempfile"

describe Konjac::Config do
  before :all do
    @config_path = File.expand_path("~/.konjac/config.yml")
    @backup_path = File.expand_path("~/.konjac/config.yml.bak")
    FileUtils.mv @config_path, @backup_path if File.exists?(@config_path)
    @env_language = ENV["LANG"]
  end

  # Restore the original configuration file
  after :all do
    FileUtils.mv @backup_path, @config_path if File.exists?(@backup_path)
    ENV["LANG"] = @env_language || ""
  end

  describe "when the configuration file is blank" do
    # Create a new configuration file before each test
    before :each do
      File.open(@config_path, "w") do |file|
        file.puts "--- {}"
      end
    end

    it "should default to English when no system language is found" do
      ENV["LANG"] = ""
      Konjac::Config.load
      Konjac::Config.language.should == :en
    end

    it "should default to English when specified" do
      ENV["LANG"] = "en"
      Konjac::Config.load
      Konjac::Config.language.should == :en
    end

    it "should default to a foreign language when specified" do
      ENV["LANG"] = "ja"
      Konjac::Config.load
      Konjac::Config.language.should == :ja
    end

    it "should default to dict as the default dictionary" do
      Konjac::Config.dictionary.should == "dict"
    end

    it "should list the available dictionaries, including dict as default" do
      Konjac::Config.list.should include "*** dict"
    end
  end
end
