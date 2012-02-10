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
          if args.empty?
            @current.formula.set text
          else
            opts = parse_args(*args)
            @document.sheets[opts[:sheet]]
                     .rows[opts[:row]]
                     .cells[opts[:cell]].formula.set text
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
          end
          tags
        end

        # Finds the paragraph indicated by the provided index
        def find(*args)
          unless args.empty?
            @indices = args
            opts = parse_args(*args)
            @current = @document.sheets[opts[:sheet]]
                                .rows[opts[:row]]
                                .cells[opts[:cell]]
          end

          @current.formula.get
        end

        # Retrieves the number of cells in the document. Note that this method
        # fetches all row and column elements and can thus be very expensive for
        # large spreadsheets.
        def size
          @document.sheets.inject(0) do |result, sheet|
            range   = sheet.used_range 
            result += range.rows.get.size * range.columns.get.size
          end
        end
        alias :length :size
      end
    end
  end
end

