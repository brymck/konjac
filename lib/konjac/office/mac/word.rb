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
          opts = super(text, *args)
          puts opts.pretty_inspect
          if opts[:type].nil? || opts[:type].empty?
            select opts
            @application.selection.type_text :text => text
          else
            @document.shapes[opts[:paragraph]].text_frame.text_range.content.set text
          end
        end

        # Creates a dump of the document's data in Tag form
        def data
          @index = 1
          @current = @document.paragraphs[@index]

          tags = []

          # An open-ended loop is necessary because requesting a paragraphs
          # enumerator will retrieve all paragraphs from the document,
          # potentially consuming a large amount of memory and freezing Word
          loop do
            temp = Tag.new
            temp.indices = [@index]
            temp.removed = temp.added = read
            tags << temp unless temp.blank?
            break if succ.nil?
          end

          # TODO: I should optimize this later like above, to prevent large
          # shapes from getting out of hand
          @document.shapes.get.each_with_index do |shape, index|
            temp = Tag.new
            temp.indices = [index + 1]
            temp.removed = temp.added =
              clean(shape.text_frame.text_range.content.get)
            temp.type = :shape
            tags << temp unless temp.blank?
          end

          tags
        end

        # Finds the paragraph indicated by the provided index
        def find(*args)
          unless args.empty? || args.nil?
            opts = parse_args(*args)
            if opts[:type].nil? && !opts[:paragraph].nil?
              @index   = opts[:paragraph]
              @current = @document.paragraphs[opts[:paragraph]]
            elsif opts[:type] == :shape
              return @document.shapes[opts[:paragraph]].text_frame.text_range.content.get
            end
          end

          @current.text_object.content.get
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
          find *args
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
