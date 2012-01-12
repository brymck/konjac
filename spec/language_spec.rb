require File.dirname(__FILE__) + "/spec_helper"

describe Language do
  it "should find English" do
    Language.find(:english).should == :en
    Language.find(:eng).should == :en
  end

  it "should find Japanese" do
    Language.find(:japanese).should == :ja
    Language.find(:jpn).should == :ja
  end

  it "should return equal results for both strings and symbols" do
    Language.find(:english).should == Language.find("english")
  end

  it "should accurately underscore languages" do
    # underscore is a private method
    Language.__send__(:underscore, "English").should == :english
    Language.__send__(:underscore, "Western Frisian").should == :western_frisian
  end
  
  it "should know that English has spaces" do
    Language.has_spaces?(:en).should == true
  end

  it "should know that Japanese does not have spaces" do
    Language.has_spaces?(:ja).should == false
  end
end
