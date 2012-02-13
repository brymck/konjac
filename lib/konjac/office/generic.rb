# coding: utf-8
module Konjac
  module Office
    # This is a basic class that contains all the methods that are universal
    # across OSes, file formats, applications, etc.
    class Generic
      autoload :Item, "konjac/office/item"

      attr_reader :document, :index, :current

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
        @index = 0
        @current = nil
      end

      def [](*args)
        opts = parse_args(*args)
        return shape_at(opts) if opts[:type] == :shape

        Item.new @item_opts.merge(opts)
      end
      alias :item_at :[]

      def []=(*args)
        write args.pop, *args
      end

      def shape_at(*args)
        opts = parse_args(*args, :type => :shape)

        Item.new @shape_opts.merge(opts)
      end

      def write(text, *args)
        item_at(*args).write text
      end

      def read(*args)
        item_at(*args).read
      end

      def tags
        Tag.load path
      end

      def export
        Tag.dump data, path
      end

      def import
        tags.each do |tag|
          if tag.changed? && !tag.blank?
            write tag.added.join(delimiter(tag.type)), *tag.indices,
              :type => tag.type
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

      def clean(text, opts)

      end
    end
  end
end
