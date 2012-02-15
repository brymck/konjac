# coding: utf-8
module Konjac
  module Office
    # This is a basic class that contains all the methods that are universal
    # across OSes, file formats, applications, etc.
    class Base
      autoload :Item, "konjac/office/item"

      # The active document
      attr_reader :document

      # Creates a new Base object
      def initialize(location = nil)
        @document = open(File.expand_path(location)) unless location.nil?
        @document = active_document
        @item_opts = {
          :application => @application,
          :document    => @document,
          :delimiter   => "\r"
        }
        @shape_opts = {
          :application => @application,
          :document    => @document,
          :delimiter   => "\v"
        }
      end

      # Finds the item at the specified indices. This method accepts both
      # variadic inputs (i.e. <tt>1, 2, 3</tt>) or the equivalent hash (i.e.
      # <tt>:sheet => 1, :row => 2, :cell => 3</tt>. The following pairs are
      # equivalent:
      #
      #   doc[1]
      #   doc[:paragraph => 1]
      #   doc.item_at 1
      #   doc.item_at :paragraph => 1
      #
      #   xl[1, 1, 1]
      #   xl.item_at :sheet => 1, :row => 1, :cell => 1
      #
      #   pp[1, 1]
      #   pp.item_at :slide => 1, :shape => 1
      #
      #   doc[1, :type => :shape]
      #   doc :shape => 1, :type => :shape
      #   doc.shape_at 1
      #
      # along with all the obvious permutations.
      def [](*args)
        opts = parse_args(*args)
        return shape_at(opts) if opts[:type] == :shape

        Item.new @item_opts.merge(opts)
      end
      alias :item_at :[]

      # Sets the item at the specified indices to the value of the first
      # argument or the <tt>:text</tt> member of the supplied hash
      def []=(*args)
        write args.pop, *args
      end

      # Retrieves the shape at the specified indices
      def shape_at(*args)
        last_item = args.last
        last_item = { :type => :shape }.merge(last_item) if last_item.is_a?(Hash)
        opts = parse_args(*args)
        Item.new @shape_opts.merge(opts)
      end

      # Writes to the item at the specified indices
      def write(text, *args)
        item_at(*args).write text
      end

      # Reads from the item at the specified indices
      def read(*args)
        item_at(*args).read
      end

      # Loads Tags from the supplied path
      def tags
        Tag.load path
      end

      # Exports Tags to the specified path
      def export
        Tag.dump data, path
      end

      # Imports Tags from the specified path into the +document+
      def import
        tags.each do |tag|
          if tag.changed? && !tag.blank?
            if tag.type == :shape
              added = tag.added.join(@shape_opts[:delimiter])
            else
              added = tag.added.join(@item_opts[:delimiter])
            end
            write added, *tag.indices, :type => tag.type
          end
        end
      end

      private

      def parse_args(*args)
        return nil if args.empty? || args.nil?

        # Extract final argument if it's a hash
        parsed = args.last.is_a?(Hash) ? args.pop : {}

        if parsed[:type] == :shape
          # Create hash using @parse_order as keys and args as values, then merge
          # that with any pre-parsed hashes. Arguments specified via the hash have
          # priority
          parsed = Hash[@shape_opts[:ref_path].zip(args)].merge(parsed)
        else
          parsed = Hash[@item_opts[:ref_path].zip(args)].merge(parsed)
        end
      end
    end
  end
end
