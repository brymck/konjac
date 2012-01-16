# coding: utf-8
require File.dirname(__FILE__) + "/spec_helper"
require "tempfile"

describe Config do
  before :all do
    @config_path = File.expand_path("~/.konjac/config.yml")
    @backup_path = File.expand_path("~/.konjac/config.yml.bak")
    FileUtils.mv @config_path, @backup_path if File.exists?(@config_path)
    @env_language = ENV["LANG"]
  end

  after :all do
    FileUtils.mv @backup_path, @config_path if File.exists?(@backup_path)
    ENV["LANG"] = @env_language || ""
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
end
