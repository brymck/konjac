require File.dirname(__FILE__) + "/spec_helper"

describe Office do
  before :each do
    @virtual_methods = %w(arity items open active_document find write read size length)
  end
  
  describe Office::Generic do
    it "should raise a virtual method error on creation" do
      lambda { Office::Generic.new }.should raise_error VirtualMethodError
    end

    it "should raise virtual method errors for most unique methods" do
      # Override any virtual errors from initialization
      class Office::Generic; def initialize; end; end

      virtual = Office::Generic.new
      @virtual_methods.each do |method|
        # Construct some dummy arguments to prevent NoMethodErrors
        args = [nil] * virtual.method(method).arity.abs
        
        lambda { virtual.send(method, *args) }.should raise_error VirtualMethodError
      end
    end
  end
end
