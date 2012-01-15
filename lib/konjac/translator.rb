# coding: utf-8
module Konjac
  module Translator
    class << self
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

      def translate_word(word, from_lang, to_lang, opts = {})
        load_dictionary from_lang, to_lang, opts

        translate_content word
      end

      def translate_content(content)
        @pairs.each do |pair|
          search, replace = pair
          content.gsub! search, replace
        end

        content
      end

      private

      def load_dictionary(from_lang, to_lang, opts)
        @pairs = Dictionary.load(from_lang, to_lang, opts)
      end
    end
  end
end
