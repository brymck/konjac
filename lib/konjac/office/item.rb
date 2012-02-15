# coding: utf-8
module Konjac
  module Office
    class Base
      # An item class dealing with hierarchy in which to search the
      # document. For example, with Word it will search paragraphs and for
      # PowerPoint it will search slides then shapes.  This class then will
      # follow the hierarchy to text objects and is capable of reading from and
      # writing to them.
      class Item
        # Creates a new Item
        def initialize(opts = {})
          @opts = opts

          item = @opts[:document]
          @opts[:ref_path].each do |node|
            item = item.send(pluralize(node))[opts[node]]
          end
          @ref = item
        end

        # Retrieves the content from the Item. Note that without getter or
        # setter methods this may not actually retrieve anything but the message
        # we intend to send to the scripting interface.
        def content
          return @content unless @content.nil?

          @content = @ref
          @opts[:content_path].each do |node|
            @content = @content.send(node)
          end
          @content
        end

        # Reads the item's text content, cleaned up according to the supplied
        # delimiters and strippable items
        def read
          clean content.send(@opts[:read])
        end

        # Writes to the item
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
