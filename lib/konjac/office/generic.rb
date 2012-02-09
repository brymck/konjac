module Konjac
  module Office
    # This is a basic virtual class that contains all the methods that must be
    # implemented across all OSes, file formats, interfaces, etc.
    class Generic
      attr_reader :document, :index

      def initialize(location = nil)
        if location.nil?
          @document = active_document
        else
          @document = open(File.expand_path(location))
        end
        @index = 0
        @current = nil
      end
      
      def arity
        virtual_error :arity
      end

      def items
        virtual_error :items
      end

      def open(path)
        virtual_error :open, path
      end

      def active_document
        virtual_error :active_document
      end

      def find(*args)
        virtual_error :find, *args
      end

      def write(text, *args)
        virtual_error :write, *args
      end

      def read(*args)
        virtual_error :read, *args
      end

      def size
        virtual_error :size
      end
      alias :length :size

      def pred
        virtual_error :pred
      end

      def succ
        virtual_error :succ
      end
      alias :next :succ

      private

      def clean(text, replacements)
        replacements.each do |replace, search|
          text.gsub! search, replace
        end
        text
      end

      def virtual_error(method, *args)
        text = "#{method}#{args.nil? ? "" : "(#{args.map(&:inspect).join(", ")}"}"
        raise VirtualMethodError.new(I18n.t(:unimplemented_virtual) % text)
      end
    end
  end
end
