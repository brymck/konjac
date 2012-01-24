# coding: utf-8
module Konjac
  # A class consisting of functions for translation
  module Translator
    DIFF_ADD = /^\+(?!\+\+ )/
    class << self
      # Translates a file or list of files
      #
      #   path = Dir[File.expand_path("~/.konjac/test_en.txt")]
      #   Translator.translate_files path, :en, :ja, :using => [:dict]
      def translate_files(files, from_lang, to_lang, opts = {})
        load_dictionary from_lang, to_lang, opts
        
        files.each do |source|
          # Handle .diff files differently (har har)
          is_diff = (File.extname(source) == ".diff")

          temp_file = Tempfile.new("konjac")
          File.open(source, "r") do |file|
            file.each_line do |line|
              if is_diff && line !~ DIFF_ADD
                temp_file.puts line
              else
                temp_file.puts translate_content(line)
              end
            end
          end
          target = Utils.build_converted_file_name(source, from_lang, to_lang)
          FileUtils.mv temp_file.path, target
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
