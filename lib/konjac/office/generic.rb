# coding: utf-8
module Konjac
  module Office
    # This is a basic class that contains all the methods that are universal
    # across OSes, file formats, applications, etc.
    class Generic
      attr_reader :document, :index, :current

      def initialize(location = nil)
        @document = open(File.expand_path(location)) unless location.nil?
        @document = active_document
        @index = 0
        @current = nil
      end

      # This only does the bare minimum, extracting arguments from
      # <tt>*args</tt>, so that subclass methods have their parameters parsed
      def write(text, *args)
        parse_args *args
      end

      def read(*args)
        opts = parse_args(*args)
        clean find(opts), (opts.nil? ? nil : opts[:type])
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

      def delimiter(type)
        if type.nil?
          "\v"
        else
          case type
          when :shape
            "\r"
          else
            "\v"
          end
        end
      end

      private

      def parse_args(*args)
        return nil if args.empty? || args.nil?

        # Extract final argument if it's a hash
        parsed = args.last.is_a?(Hash) ? args.pop : {}

        # Create hash using @parse_order as keys and args as values, then merge
        # that with any pre-parsed hashes. Arguments specified via the hash have
        # priority
        parsed = Hash[@parse_order.zip(args)].merge(parsed)
      end

      def clean(text, type = nil)
        text.gsub(@strippable, "").split delimiter(type)
      end
    end
  end
end
