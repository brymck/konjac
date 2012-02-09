# coding: utf-8
module Konjac
  module Office
    module Mac
      class Word < Shared
        def initialize(path = nil)
          super "Microsoft Word", path
          @strippable = /[\r\n\a]+$/
          @index = 0
          @current = @document.paragraphs[@index]
        end

        # Retrieves the active document and caches it
        def active_document
          @active_document ||= @application.active_document
        end

        def write(text, paragraph_index = nil)
          select paragraph_index
          @application.selection.type_text :text => text
        end

        # Reads the paragraph at the provided index, or the current paragraph if
        # no index is provided
        def read(paragraph_index = nil)
          find(paragraph_index).get.gsub(@strippable, "").split @delimiter
        end

        # Creates a dump of the document's data in Tag form
        def data
          @index = 1
          @current = @document.paragraphs[@index]

          tags = []
          loop do
            temp = Tag.new
            temp.indices = [@index]
            temp.removed = temp.added = read
            tags << temp unless temp.blank?
            break if next.nil?
          end

          tags
        end

        # Retrieves the POSIX path of the document
        def path
          @path ||= posix_path(@document.full_name.get)
        end

        # Finds the paragraph indicated by the provided index
        def find(paragraph_index = nil)
          unless paragraph_index.nil?
            @index = paragraph_index
            @current = @document.paragraphs[paragraph_index]
          end

          @current.text_object.content
        end

        # Retrieves the number of paragraphs in the document. Note that this
        # method fetches all paragraphs elements and can thus be very expensive
        # for large documents.
        def size
          @document.paragraphs.get.size
        end
        alias :length :size

        # Goes to the next paragraph
        def next
          @index  += 1
          @current = @current.next_paragraph
        rescue
          nil
        end
        alias :next :next

        # Selects the paragraph indicated by an indicated, or +nil+ to select
        # the current paragraph
        def select(paragraph_index = nil)
          find paragraph_index
          para_start = @current.text_object.start_of_content.get
          para_end   = @current.text_object.end_of_content.get
          range      = active_document.create_range(:start => para_start,
                                                    :end_ => para_end)

          # Move in end of range by length of stripped content less end of table
          # mark
          strip_size = range.content.get[@strippable].gsub(/\a/, "").size
          range      = active_document.create_range(:start => para_start,
                                                    :end_ => para_end - strip_size)
          range.select
        end
      end
    end
  end
end
