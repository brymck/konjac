module Konjac
  # A class for suggesting translations
  class Suggestor
    # A list of all pairs available
    attr_accessor :pairs

    # The default suggested count
    SUGGEST_COUNT  = 10

    # The default suggest cutoff
    SUGGEST_CUTOFF = 0.5

    # Creates a new Suggestor object
    def initialize(from_lang, to_lang, opts = {})
      @pairs = Dictionary.load(from_lang, to_lang, opts)
    end

    # Provides suggested translations for a word, providing an array containing
    # the pair distance, fuzzy match used and the suggested replacement
    def suggest(word, opts = {})
      # Set defaults for optional arguments
      opts = {
        :count  => SUGGEST_COUNT,
        :cutoff => SUGGEST_CUTOFF
      }.merge opts

      results = []
      matcher = Amatch::PairDistance.new(word)
      @pairs.each do |search, replace, fuzzy|
        if fuzzy.is_a?(String)
          value = matcher.match(fuzzy)
        else
          value = (search =~ word ? 1 : 0)
        end

        if (results.empty? || value > results[0][0]) && value >= opts[:cutoff]
          results << [value, fuzzy, replace]
          results.sort!
          results.shift if results.length > opts[:count]
        end
      end
      results.reverse
    end
  end
end
