# coding: utf-8
module Konjac
  module Office
    module Mac
      class PowerPoint < Shared
        def initialize(path = nil)
          super "Microsoft PowerPoint", path
          @strippable = //
          @parse_order = [:slide, :shape]
          @item_opts.merge!({
            :ref_path     => [:slide, :shape],
            :content_path => [:text_frame, :text_range, :content],
            :strippable   => //
          })
          @shape_opts = @item_opts
        end

        # Retrieves the active document and caches it
        def active_document
          @active_document ||= @application.active_presentation
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

        # Retrieves the number of cells in the document. Note that this method
        # fetches all row and column elements and can thus be very expensive for
        # large spreadsheets.
        def size
        end
        alias :length :size
      end
    end
  end
end
