module Konjac
  module Tag
    attr_accessor :index, :original, :translated

    def initialize(index, original, translated)
      @index, @original, @translated = index, original, translated
    end

    def to_s
      "[[KJ-#{index}]]\n> #{original}#{"\n" + translated if translated?}"
    end

    def translated?
      !!translated
    end

    class << self
      attr_accessor :all

      STARTS_WITH_CLOSE_TAG = /^\>/
      KONJAC_TAG = /^\[\[KJ\-(\d+)\]\]$/

      def load_from_file(path)
        @tags = []
        lines = File.readlines(path)

        first_line = true
        index      = nil
        orig       = nil
        trans      = nil

        lines.each do |line|
          if line =~ KONJAC_TAG
            index = line.match(KONJAC_TAG)[1].tr("\n", "")
          elsif line =~ STARTS_WITH_CLOSE_TAG
            orig = line.match(STARTS_WITH_CLOSE_TAG)[1].tr("\n", "")
          else
            trans = line.tr("\n", "")
            unless index.nil?
              @tags << Tag.new(index, orig, trans)
            end
          end

          first_line = false
        end
      end
    end
  end
end
