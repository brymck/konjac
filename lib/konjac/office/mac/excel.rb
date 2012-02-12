# coding: utf-8
module Konjac
  module Office
    module Mac
      class Excel < Shared
        def initialize(path = nil)
          super "Microsoft Excel", path
          @strippable = //
          @delimiter = "\r"
          @parse_order = [:sheet, :row, :cell]
          find 1, 1, 1
        end

        # Retrieves the active document and caches it
        def active_document
          @active_document ||= @application.active_workbook
        end

        def write(text, *args)
          opts = super(text, *args)
          if opts.map(&:last).all?(&:nil?)
            @current.formula.set text
          elsif opts[:type].nil? || opts[:type].empty?
            opts = parse_args(*args)
            @document.sheets[opts[:sheet]]
                     .rows[opts[:row]]
                     .cells[opts[:cell]].formula.set text
          else
            @document.sheets[opts[:sheet]]
                     .shapes[opts[:row]].text_frame.characters.content.set text
          end
        end

        # Creates a dump of the spreadsheet's data in Tag form
        def data
          tags = []
          @document.sheets.get.each_with_index do |sheet, s|
            sheet.used_range.rows.get.each_with_index do |row, r|
              row.cells.get.each_with_index do |cell, c|
                temp = Tag.new
                temp.indices = [s + 1, r + 1, c + 1]
                temp.removed = temp.added = read(s + 1, r + 1, c + 1)
                tags << temp unless temp.blank?
              end
            end

            # TODO: I should optimize this later like above, to prevent large
            # shapes from getting out of hand
            sheet.shapes.get.each_with_index do |shape, index|
              temp = Tag.new
              temp.indices = [s + 1, index + 1]
              temp.removed = temp.added =
                clean(shape.text_frame.characters.content.get, :shape)
              temp.type = :shape
              tags << temp unless temp.blank?
            end rescue NoMethodError  # ignore sheets without shapes
          end
          tags
        end

        # Finds the paragraph indicated by the provided index
        # TODO: Clean up the second unless statement
        def find(*args)
          unless args.empty? || args.nil?
            opts = parse_args(*args)
            if (opts[:type].nil? || opts[:type].empty?) && !opts.map(&:last).all?(&:nil?)
              @index   = [opts[:sheet], opts[:row], opts[:cell]]
              @current = @document.sheets[opts[:sheet]]
                                  .rows[opts[:row]]
                                  .cells[opts[:cell]]
            elsif opts[:type] == :shape
              return @document.sheets[opts[:sheet]]
                              .shapes[opts[:row]].text_frame.characters.content.get
            end
          end

          @current.formula.get
        end

        # Retrieves the number of cells in the document. Note that this method
        # fetches all row and column elements and can thus be very expensive for
        # large spreadsheets.
        def size
          @document.sheets.get.inject(0) do |result, sheet|
            range   = sheet.used_range 
            result += range.rows.get.size * range.columns.get.size
          end
        end
        alias :length :size
      end
    end
  end
end
