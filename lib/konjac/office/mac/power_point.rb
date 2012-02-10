# coding: utf-8
module Konjac
  module Office
    module Mac
      class PowerPoint < Shared
        def initialize(path = nil)
          super "Microsoft PowerPoint", path
          @strippable = //
          @delimiter = "\r"
          @parse_order = [:slide, :shape]
          find 1, 1
        end

        # Retrieves the active document and caches it
        def active_document
          @active_document ||= @application.active_presentation
        end

        def write(text, *args)
          if args.empty?
            @current.text_frame.text_range.content.set text
          else
            opts = parse_args(*args)
            @document.slides[opts[:slide]]
                     .shapes[opts[:shape]].text_frame.text_range.content.set text
          end
        end

        # Creates a dump of the spreadsheet's data in Tag form
        def data
          tags = []
          @document.slides.get.each_with_index do |slide, sl|
            slide.shapes.get.each_with_index do |shape, sh|
              temp = Tag.new
              temp.indices = [sl + 1, sh + 1]
              temp.removed = temp.added = read(sl + 1, sh + 1)
              tags << temp unless temp.blank?
            end
          end
          tags
        end

        # Finds the paragraph indicated by the provided index
        def find(*args)
          unless args.empty?
            @indices = args
            opts = parse_args(*args)
            @current = @document.slides[opts[:slide]]
                                .shapes[opts[:shape]]
          end

          @current.text_frame.text_range.content.get
        end

        # Retrieves the number of cells in the document. Note that this method
        # fetches all row and column elements and can thus be very expensive for
        # large spreadsheets.
        def size
        end
        alias :length :size

        def delimiter(type = nil)
          "\r"
        end
      end
    end
  end
end
