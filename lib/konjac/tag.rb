# coding: utf-8
module Konjac
  # A tag containing original text and (if available) its translation, plus the
  # index of the <w:t> tag extracted from its .docx document
  class Tag
    # The index of the <w:t> tag in the cleaned-up XML file output by
    # Konjac::Word.export_docx_tags
    attr_accessor :index
    
    # The original text
    attr_accessor :original
      
    # The translated text
    attr_accessor :translated

    # Creates a new tag.
    #
    #   t = Tag.new(1, "dog", "犬")
    def initialize(index, original, translated)
      @index, @original, @translated = index, original, translated
    end

    # Converts the Tag into a string for use in .konjac files
    #
    # <tt>Tag.new(1, "dog", "犬").to_s</tt> will output
    #
    #   [[KJ-1]]
    #   > dog
    #   犬
    #
    # whereas <tt>Tag.new(2, "cat").to_s</tt> will output
    #
    #   [[KJ-2]]
    #   > cat
    def to_s
      "[[KJ-#{index}]]\n> #{original}#{"\n" + translated if translated?}"
    end

    # Whether the tag has been translated
    #
    #   dog = Tag.new(1, "dog", "犬")
    #   dog.translated? # => true
    #
    #   cat = Tag.new(1, "cat", "")
    #   cat.translated? # => false
    def translated?
      !translated.nil? && translated != ""
    end
  end
end
