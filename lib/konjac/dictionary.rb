require "yaml"

module Konjac
  module Dictionary
    class << self
      attr_accessor :from_lang, :to_lang, :path

      def load(from_lang, to_lang, opts = {})
        # Set defaults for optional arguments
        opts = { :force => false, :name => "dict" }.merge(opts)
        
        # Parse languages
        from_lang = parse_language(from_lang)
        to_lang = parse_language(to_lang)

        # Get full path from name
        full_path = File.expand_path("~/.konjac/#{opts[:name]}.yml")
        
        return @pairs if loaded?(from_lang, to_lang, full_path)

        # Cache load
        cache_load from_lang, to_lang, opts
        
        # Make sure dictionary exists and load
        verify_dictionary_exists full_path
        @dictionary = ::YAML.load_file(full_path)

        # Build a list of search and replace pairs
        @pairs = []
        @dictionary["terms"].each do |term|
          if term.has_key?(from_lang) && term.has_key?(to_lang)
            @pairs << [term[from_lang], term[to_lang]]
          end
        end

        @pairs
      end

      def verify_dictionary_exists(full_path)
        unless File.file?(full_path)
          FileUtils.mkpath File.dirname(full_path)
          FileUtils.touch full_path
        end
      end

      def loaded?(from_lang, to_lang, opts)
        opts[:force] || (@from_lang == from_lang &&
                         @to_lang   == to_lang   &&
                         @path      == opts[:path])
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
