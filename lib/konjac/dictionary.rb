require "yaml"

module Konjac
  module Dictionary
    class << self
      attr_accessor :from_lang, :to_lang, :dictionaries, :pairs

      BLANK = /^\s*$/

      def load(from_lang, to_lang, dictionaries, opts = {})
        # Set defaults for optional arguments
        opts = { :force => false }.merge(opts)
        dictionaries = ["dict"] if dictionaries.nil?
        
        # Allow both symbol and string arguments for languages
        from_lang = from_lang.to_s
        to_lang   = to_lang.to_s

        # Ignore everything if we've been here before
        return @pairs if loaded?(from_lang, to_lang, dictionaries) || opts[:force]
        
        # Build a regex template for the from language
        from_template = build_regex_template(from_lang)
        to_template   = build_replacement_template(from_lang, to_lang)

        # Save variables to cache so we can avoid repetitive requests
        cache_load from_lang, to_lang, dictionaries
        
        # Make sure dictionary exists and load
        @dictionary = []
        dictionaries.each do |dict|
          if dict =~ /[\/.]/
            sub_dictionaries = Dir.glob(File.expand_path(dict))
          else
            sub_dictionaries = Dir.glob(File.expand_path("~/.konjac/#{dict}.yml"))
          end

          sub_dictionaries.each do |sub_dict|
            verify_dictionary_exists sub_dict
            temp = ::YAML.load_file(sub_dict)
            @dictionary += temp if temp.is_a?(Array)
          end
        end

        # Build a list of search and replace pairs
        @pairs = []
        @dictionary.each do |term|
          pair = extract_pair_from_term(term, from_lang, to_lang, from_template, to_template)
          @pairs << pair unless pair.nil?
        end

        @pairs
      end

      def extract_pair_from_term(term, from_lang, to_lang, from_template, to_template)
        if term.has_key?(to_lang)
          # Build to term depending on whether it's a hash for complex
          # matches or a simple string
          if term[to_lang].is_a?(Hash)
            to_term = term[to_lang][to_lang]

            if term[to_lang].has_key?(from_lang)
              from_term = term[to_lang][from_lang]
            end
          else
            to_term = term[to_lang]
          end

          # Build from term if it doesn't already exist
          if term.has_key?(from_lang) && from_term.nil?
            from_term = term[from_lang]
          end

          unless from_term.nil?
            # Build a regular expression if it isn't already one.
            # Note that this will apply word boundary rules, so to avoid them
            # create a regular expression in the dictionary file.
            # Matching is case-insensitive unless the expression contains a
            # capital letter.
            unless from_term.is_a?(Regexp)
              from_term = Regexp.new(from_template % from_term,
                                     ("i" unless from_term =~ /[A-Z]/))
            end

            to_term = to_template % to_term unless to_term =~ BLANK

            return [ from_term, to_term ]
          end
        end

        # Return nil if no term could be constructed
        return nil
      end

      # Verifies whether the dictionary exists on the specified path, creating
      # a blank file if it doesn't
      def verify_dictionary_exists(full_path)
        unless File.file?(full_path)
          FileUtils.mkpath File.dirname(full_path)
          FileUtils.touch full_path
        end
      end

      # Tests whether the same from language, to language and dictionary path
      # have been loaded before
      def loaded?(from_lang, to_lang, dictionaries)
        (@from_lang    == from_lang) &&
        (@to_lang      == to_lang  ) &&
        (@dictionaries == dictionaries)
      end

      # Builds a regular expression template for the language depending on
      # whether that language has word boundaries
      def build_regex_template(lang)
        if Language.has_spaces?(lang)
          "\\b%s\\b"
        else
          "%s"
        end
      end

      # Builds a replacement template for the to language, depending on whether
      # the both from and to languages allow for whitespace
      def build_replacement_template(from_lang, to_lang)
        if !Language.has_spaces?(from_lang) && Language.has_spaces?(to_lang)
          "%s "
        else
          "%s"
        end
      end

      private

      def parse_language(lang)
        if @dictionary["languages"].has_key?(lang)
          return lang
        else
          @dictionary["languages"].each do |main, alternatives|
            return main if alternatives.include?(lang)
          end

          # If no match is found, give an error message and exit
          raise Exceptions::InvalidLanguageError.new("No match found for language \"#{lang}\"")
          exit 1
        end
      end

      # Caches variables so we can determine later on whether to reload the
      # dictionaries or not
      def cache_load(from_lang, to_lang, dictionaries)
        @from_lang    = from_lang
        @to_lang      = to_lang
        @dictionaries = dictionaries
      end
    end
  end
end
