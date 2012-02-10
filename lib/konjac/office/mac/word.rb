# coding: utf-8
module Konjac
  module Office
    module Mac
      class Word < Shared
        def initialize(path = nil)
          super "Microsoft Word", path
          @strippable = /[\r\n\a]+$/
          @index = 1
          @current = @document.paragraphs[@index]
          @parse_order = [:paragraph]
        end

        # Retrieves the active document and caches it
        def active_document
          @active_document ||= @application.active_document
        end

        def write(text, *args)
          opts = super(args)
          select opts[:paragraph]
          @application.selection.type_text :text => opts[:text]
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
            break if succ.nil?
          end

          tags
        end

        # Finds the paragraph indicated by the provided index
        def find(*args)
          unless args.empty? || args.nil?
            opts     = parse_args(*args)
            @index   = opts[:paragraph]
            @current = @document.paragraphs[opts[:paragraph]]
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
        def succ
          @index  += 1
          @current = @current.next_paragraph
        rescue
          @index  -= 1
          nil
        end
        alias :next :succ

        # Selects the paragraph indicated by an indicated, or +nil+ to select
        # the current paragraph
        def select(*args)
          opts = parse_args(*args)
          find opts
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
