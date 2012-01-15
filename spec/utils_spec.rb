require File.dirname(__FILE__) + "/spec_helper"
require "tempfile"

describe Utils do
  it "should extract the correct language from a filename" do
    Utils.extract_language_code_from_filename("test_en.txt").should == "en"
  end

  it "should correctly rename a file according to its target language" do
    Utils.build_converted_file_name("./test_en.txt", "en", "ja").should == "./test_ja.txt"
    Utils.build_converted_file_name("./test.txt", "en", "ja").should == "./test_ja.txt"
    Utils.build_converted_file_name("./test_fr.txt", "en", "ja").should == "./test_fr_ja.txt"
  end

  describe "when forcing an extension" do
    before :each do
      @konjac = Tempfile.new(["test", ".konjac"])
      @kon2   = Tempfile.new(["test2", ".konjac"])
      @docx   = Tempfile.new(["test", ".docx"])
      @doc2   = Tempfile.new(["test2", ".docx"])
    end

    it "should work when the user does not specify an extension" do
      files_found = Utils.parse_files("#{Dir.tmpdir}/*", ".konjac")
      files_found.should include @konjac.path
      files_found.should include @kon2.path
      files_found.should_not include @docx.path
      files_found.should_not include @doc2.path
      files_found = Utils.parse_files("#{Dir.tmpdir}/*", ".docx")
      files_found.should include @docx.path
      files_found.should include @doc2.path
      files_found.should_not include @konjac.path
      files_found.should_not include @kon2.path
    end

    it "should work when the user does specify an extension" do
      files_found = Utils.parse_files("#{Dir.tmpdir}/*.docx", ".konjac")
      files_found.should include @konjac.path
      files_found.should include @kon2.path
      files_found.should_not include @docx.path
      files_found.should_not include @doc2.path
      files_found = Utils.parse_files("#{Dir.tmpdir}/*.docx", ".docx")
      files_found.should include @docx.path
      files_found.should include @doc2.path
      files_found.should_not include @konjac.path
      files_found.should_not include @kon2.path
    end

    it "should work when the user supplies wildcards" do
      files_found = Utils.parse_files("#{Dir.tmpdir}/*.*", ".konjac")
      files_found.should include @konjac.path
      files_found.should include @kon2.path
      files_found.should_not include @docx.path
      files_found.should_not include @doc2.path
      files_found = Utils.parse_files("#{Dir.tmpdir}/*.*", ".docx")
      files_found.should include @docx.path
      files_found.should include @doc2.path
      files_found.should_not include @konjac.path
      files_found.should_not include @kon2.path
    end
  end
end
