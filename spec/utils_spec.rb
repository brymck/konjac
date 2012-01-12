require File.dirname(__FILE__) + "/spec_helper"

describe Utils do
  it "should extract the correct language from a filename" do
    Utils.extract_language_code_from_filename("test_en.txt").should == "en"
  end

  it "should correctly rename a file according to its target language" do
    Utils.build_converted_file_name("./test_en.txt", "en", "ja").should == "./test_ja.txt"
    Utils.build_converted_file_name("./test.txt", "en", "ja").should == "./test_ja.txt"
    Utils.build_converted_file_name("./test_fr.txt", "en", "ja").should == "./test_fr_ja.txt"
  end
end
