describe Office do
  before :each do
    @env = Office.environment

    module Office::Mac
      class Excel;      def initialize; end; end
      class PowerPoint; def initialize; end; end
      class Word;       def initialize; end; end
    end

    module Office::Windows
      class Excel;      def initialize; end; end
      class PowerPoint; def initialize; end; end
      class Word;       def initialize; end; end
    end
  end

  describe "dynamic methods" do
    it "should fail to detect something made-up" do
      lambda { Office.something_made_up }.should raise_error NoMethodError
    end

    it "should detect Excel" do
      Office.excel.should be_an_instance_of @env::Excel
    end

    it "should detect PowerPoint" do
      Office.power_point.should be_an_instance_of @env::PowerPoint
    end

    it "should detect Word" do
      Office.word.should be_an_instance_of @env::Word
    end
  end
end
