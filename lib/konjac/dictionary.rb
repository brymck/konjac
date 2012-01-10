require "yaml"

module Konjac
  module Dictionary
    class << self
      def load(from_lang, to_lang, opts = {})
        opts = { :force => false }.merge(opts)
        return @pairs if loaded? && !opts[:force]


        dict_dir = File.expand_path("~/.konjac/")
        dict_path = dict_dir + "/dict.yml"

        unless File.file?(dict_path)
          FileUtils.mkpath dict_dir
          FileUtils.touch dict_path
        end

        @dictionary = ::YAML.load_file(dict_path)

        # Parse languages
        from_lang = parse_language(from_lang)
        to_lang = parse_language(to_lang)

        # Build a list of search and replace pairs
        @pairs = []
        @dictionary["terms"].each do |term|
          if term.has_key?(from_lang) && term.has_key?(to_lang)
            @pairs << [term[from_lang], term[to_lang]]
          end
        end

        @loaded = true
        @pairs
      end

      private

      def loaded?
        !!@loaded
      end

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
    end
  end
end
