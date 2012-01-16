# coding: utf-8
module Konjac
  # A class consisting of functions for translation
  module Translator
    class << self
      # Translates a file or list of files
      #
      #   path = Dir[File.expand_path("~/.konjac/test_en.txt")]
      #   Translator.translate_files path, :en, :ja, :using => [:dict]
      def translate_files(files, from_lang, to_lang, opts = {})
        load_dictionary from_lang, to_lang, opts
        
        files.each do |source|
          # Read in file and replace matches in content
          content = File.read(source)
          content = translate_content(content)

          # Write changed content to file
          File.open(Utils.build_converted_file_name(source, from_lang, to_lang), "w") do |file|
            file.puts content
          end
        end
      end

      # Loads the dictionary, then translates a word or phrase from the
      # specified language into another language
      def translate_word(word, from_lang, to_lang, opts = {})
        load_dictionary from_lang, to_lang, opts

        translate_content word
      end

      # Translates content according to the current dictionaries and to/from
      # languages
      def translate_content(content)
        @pairs.each do |pair|
          search, replace = pair
          content.gsub! search, replace
        end

        content
      end

      # Loads the parsed contents of a dictionary into the translator
      def load_dictionary(from_lang, to_lang, opts)
        @pairs = Dictionary.load(from_lang, to_lang, opts)
      end
    end
  end
end
