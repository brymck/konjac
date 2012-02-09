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
        @delimiter = "\v"
        @index = 0
        @current = nil
      end

      def read(*args)
        find(*args).get.gsub(@strippable, "").split @delimiter
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
            write tag.added.join(@delimiter), *tag.indices
          end
        end
      end
    end
  end
end
