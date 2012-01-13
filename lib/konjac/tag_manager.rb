module Konjac
  class TagManager
    attr_accessor :tags

    STARTS_WITH_CLOSE_TAG = /^\>/
    KONJAC_TAG = /^\[\[KJ\-(\d+)\]\]/

    def initialize(path)
      @tags = []
      parse_lines File.readlines(path)
    end

    def parse_lines(lines)
      index      = nil
      orig       = nil
      trans      = nil

      lines.each do |line|
        if line =~ KONJAC_TAG
          # Handle instances where there is no translation
          unless orig.nil?
            @tags << Tag.new(index, orig, trans)
            index = nil
            orig  = nil
          end

          index = line.match(KONJAC_TAG)[1].to_i
        elsif line =~ STARTS_WITH_CLOSE_TAG
          orig = line[2..-1].chomp
        else
          trans = line.chomp
          unless index.nil?
            @tags << Tag.new(index, orig, trans)
            index = nil
            orig  = nil
            trans = nil
          end
        end
      end
    end

    def all
      @tags
    end

    def [](index)
      @tags[index]
    end
  end
end
