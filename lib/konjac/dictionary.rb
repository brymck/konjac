require "yaml"

module Konjac
  module Dictionary
    class << self
      attr_accessor :from_lang, :to_lang, :path

      def load(from_lang, to_lang, opts = {})
        # Set defaults for optional arguments
        opts = { :force => false, :name => "dict" }.merge(opts)
        
        # Allow both symbol and string arguments for languages
        from_lang = from_lang.to_s
        to_lang   = to_lang.to_s

        # Build a regex template for the from language
        from_template = build_regex_template(from_lang)
        to_template   = build_replacement_template(from_lang, to_lang)

        # Get full path from name
        full_path = File.expand_path("~/.konjac/#{opts[:name]}.yml")
        
        return @pairs if loaded?(from_lang, to_lang, full_path) || opts[:force]

        # Save variables to cache so we can avoid repetitive requests
        cache_load from_lang, to_lang, opts
        
        # Make sure dictionary exists and load
        verify_dictionary_exists full_path
        @dictionary = ::YAML.load_file(full_path)

        # Build a list of search and replace pairs
        @pairs = []
        @dictionary.each do |term|
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
              # Build a regular expression if it isn't already one
              # Note that this will apply word boundary rules, so to avoid them
              # create a regular expression in the dictionary file
              unless from_term.is_a?(Regexp)
                from_term = Regexp.new(from_template % from_term)
              end
              to_term = to_template % to_term

              @pairs << [ from_term, to_term ]
            end
          end
        end

        @pairs
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
      def loaded?(from_lang, to_lang, full_path)
        (@from_lang == from_lang) &&
        (@to_lang   == to_lang  ) &&
        (@path      == full_path)
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

      def cache_load(from_lang, to_lang, opts)
        @from_lang = from_lang
        @to_lang   = to_lang
        @path      = path
      end
    end
  end
end
