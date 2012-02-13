# coding: utf-8
module Konjac
  module Office
    class Generic
      class Item
        def initialize(opts, document, ref_path, content_path, read_method, write_method)
          @content_path = content_path
          @read_method  = read_method
          @write_method = write_method

          item = document
          ref_path.each do |node|
            item = item.send(pluralize(node))[opts[node]]
          end
          @ref = item
        end

        def content
          return @content unless @content.nil?

          @content = @ref
          @content_path.each do |node|
            @content = @content.send(node)
          end
          @content
        end

        def read
          content.send @read_method
        end

        def write(text)
          content.send @write_method, text
        end

        private

        # Definitely the most naive pluralization method ever, but there's no
        # sense using an implementation as detailed as ActiveSupport's until a
        # use case arises
        def pluralize(text)
          "#{text.to_s}s"
        end
      end
    end
  end
end
