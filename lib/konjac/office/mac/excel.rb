# coding: utf-8
module Konjac
  module Office
    module Mac
      class Excel < Shared
        def initialize(path = nil)
          super "Microsoft Excel", path
          @strippable = //
          @delimiter = "\r"
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
            sheet, row, cell = args
            @document.sheets[sheet].rows[row].cells[cell].formula.set text
          end
        end

        # Creates a dump of the spreadsheet's data in Tag form
        def data
          tags = []
          @document.sheets.get.each_with_index do |sheet, s|
            sheet.used_range.rows.get.each_with_index do |row, r|
              # Retry at 0 because the interface with Excel with offering the
              # initial rows and columns twice, once at an index of 0 and once
              # at an index of 1
              next if r == 0

              row.cells.get.each_with_index do |cell, c|
                next if c == 0

                temp = Tag.new
                temp.indices = [s, r, c]
                temp.removed = temp.added = read(s, r, c)
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
            sheet, row, cell = args
            @current = @document.sheets[sheet].rows[row].cells[cell]
          end

          @current.formula
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

        # Goes to the next paragraph
        def succ
          @index  += 1
          @current = @current.next_paragraph
        rescue
          nil
        end
        alias :next :succ

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

