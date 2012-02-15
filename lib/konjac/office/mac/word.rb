# coding: utf-8
module Konjac
  module Office
    module Mac
      # Word for Mac
      class Word < Shared
        # A basic class to deal with Word's ridiculously awful handling
        # of replacing text in paragraphs.  Instead of simply setting the
        # paragraph's text to something new, you have to select all but the last
        # character (which is a newline) then write.  Otherwise, your paragraph
        # might inherit the formatting of the line below it, which is especially
        # a problem with tables.
        class WordItem < Item
          # Writes to a Word item
          def write(text)
            para_start = @ref.text_object.start_of_content.get
            para_end   = @ref.text_object.end_of_content.get
            range      = @opts[:document].create_range(:start => para_start,
                                                       :end_ => para_end - 1)
            range.select
            @opts[:application].selection.type_text :text => text
          end
        end

        # Creates a new Word item
        def initialize(path = nil)
          super "Microsoft Word", path
          @item_opts.merge!({
            :ref_path     => [:paragraph],
            :content_path => [:text_object, :content],
            :delimiter    => "\v",
            :strippable   => /[\r\n\a]+$/
          })
          @shape_opts.merge!({
            :ref_path     => [:shape],
            :content_path => [:text_frame, :text_range, :content],
            :strippable   => /[\r\n\a]+$/
          })
        end

        # This overrides the Base#[] method because we need to have a slightly
        # modified version of the Item object to enable the selection of
        # paragraph text before writing to it
        def [](*args)
          opts = parse_args(*args)
          if opts[:type].nil? || opts[:type].empty?
            WordItem.new @item_opts.merge(opts)
          else
            shape_at opts
          end
        end
        alias :item_at :[]

        # Retrieves the active document and caches it
        def active_document
          @active_document ||= @application.active_document
        end

        # Creates a dump of the document's data in Tag form
        def data
          i = 1
          tags = []
          begin
            loop do
              temp = Tag.new
              temp.indices = [i]
              temp.removed = temp.added = item_at(i).read
              tags << temp unless temp.blank?
              i += 1
            end
          rescue Appscript::CommandError
          end

          # TODO: I should optimize this later like above, to prevent large
          # shapes from getting out of hand
          i = 1
          begin
            loop do
              temp = Tag.new
              temp.indices = [i]
              temp.removed = temp.added = shape_at(i).read
              temp.type = :shape
              tags << temp unless temp.blank?
              i += 1
            end
          rescue Appscript::CommandError, TypeError
          end

          tags
        end

        # Retrieves the number of paragraphs in the document. Note that this
        # method fetches all paragraphs elements and can thus be very expensive
        # for large documents.
        def size
          @document.paragraphs.get.size
        end
        alias :length :size
      end
    end
  end
end
