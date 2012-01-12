require File.dirname(__FILE__) + "/spec_helper"

describe Languages do
  it "should find English" do
    Languages.find(:english).should == :en
    Languages.find(:eng).should == :en
  end

  it "should find Japanese" do
    Languages.find(:japanese).should == :ja
    Languages.find(:jpn).should == :ja
  end

  it "should work for both strings and symbols" do
    Languages.find(:english).should == Languages.find("english")
  end

  it "should accurately underscore languages" do
    # underscore is a private method
    Languages.__send__(:underscore, "English").should == :english
    Languages.__send__(:underscore, "Western Frisian").should == :western_frisian
  end
end
