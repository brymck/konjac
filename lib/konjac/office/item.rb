# coding: utf-8
module Konjac
  module Office
    class Generic
      class Item
        def initialize(opts = {})
          @opts = opts

          item = @opts[:document]
          @opts[:ref_path].each do |node|
            item = item.send(pluralize(node))[opts[node]]
          end
          @ref = item
        end

        def content
          return @content unless @content.nil?

          @content = @ref
          @opts[:content_path].each do |node|
            @content = @content.send(node)
          end
          @content
        end

        def read
          clean content.send(@opts[:read])
        end

        def write(text)
          content.send @opts[:write], text
        end

        private

        # Definitely the most naive pluralization method ever, but there's no
        # sense using an implementation as detailed as ActiveSupport's until a
        # use case arises
        def pluralize(text)
          "#{text.to_s}s"
        end

        def clean(text)
          text.gsub(@opts[:strippable], "").split(@opts[:delimiter])
        end
      end
    end
  end
end
