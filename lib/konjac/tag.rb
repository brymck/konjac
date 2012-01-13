module Konjac
  class Tag
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
  end
end
