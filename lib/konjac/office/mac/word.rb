module Konjac
  module Office
    module Mac
      class Word < Shared
        SUBSTITUTIONS = {
          :doc_to_rb => [
            [ "",   /[\r\n]+$/ ],
            [ "\n", /\v/       ]
          ],
          :rb_to_diff => [
          ]
        }

        def initialize(path = nil)
          @application = Appscript.app("Microsoft Word")
          super
          @index = 1
          @current = @document.paragraphs[@index]
        end

        def active_document
          @active_document ||= @application.active_document
        end

        def write(text, paragraph_index = nil)
          find(paragraph_index).set clean(text, SUBSTITUTIONS[:rb_to_diff])
        end

        def read(paragraph_index = nil)
          clean find(paragraph_index).get, SUBSTITUTIONS[:doc_to_rb]
        end

        def find(paragraph_index = nil)
          unless paragraph_index.nil?
            if paragraph_index < @index
              pred while paragraph_index > @index
            elsif paragraph_index > @index
              succ while paragraph_index > @index
            end
          end

          @current.text_object.content
        end

        def size
          @document.paragraphs.get.size
        end
        alias :length :size

        def pred
          begin
            @index  -= 1
            @current = @current.previous_paragraph
          rescue
            nil
          end
        end

        def succ
          begin
            @index  += 1
            @current = @current.next_paragraph
          rescue
            nil
          end
        end
        alias :next :succ
      end
    end
  end
end
