# coding: utf-8
require File.dirname(__FILE__) + "/../spec_helper"

describe Office::Generic do
  before :each do
    # Nuke initializer
    class Office::Generic
      def initialize
        @parse_order = [:paragraph]
      end
    end

    @generic = Office::Generic.new
  end

  describe "argument parsing" do
    describe "the first time" do
      it "should handle no arguments" do
        @generic.send(:parse_args).should == nil
      end

      it "should handle one hash" do
        @generic.send(:parse_args, :paragraph => 1).should == { :paragraph => 1 }
      end

      it "should handle one argument" do
        @generic.send(:parse_args, 1).should == { :paragraph => 1 }
      end

      it "should give a hash precedence over another argument" do
        @generic.send(:parse_args, 1, :paragraph => 2).should == { :paragraph => 2 }
      end

      describe "document types with multiple levels" do
        before :each do
          @generic.instance_variable_set :@parse_order, [:sheet, :row, :cell]
        end

        it "should handle a hash with several values" do
          @generic.send(:parse_args, :sheet => 1, :row => 2, :cell => 3)
            .should == { :sheet => 1, :row => 2, :cell => 3 }
        end

        it "should handle several arguments" do
          @generic.send(:parse_args, 1, 2, 3).should == { :sheet => 1, :row => 2, :cell => 3 }
        end
      end
    end

    describe "multiple times" do
      before :each do
        @result   = nil
        @multiple = 3
      end

      it "should correctly handle no arguments" do
        @multiple.times do
          @result = @generic.send(:parse_args)
          @result.should == nil
        end
      end

      it "should correctly handle a completed hash" do
        @generic.instance_variable_set :@parse_order, []
        @multiple.times do
          @result = @generic.send(:parse_args, :sheet => 1, :row => 2, :cell => 3)
          @result.should == { :sheet => 1, :row => 2, :cell => 3 }
        end
      end
    end
  end
end
