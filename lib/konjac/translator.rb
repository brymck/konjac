# coding: utf-8
module Konjac
  module Translator
    class << self
      def translate(files, from_lang, to_lang, dictionaries)
        pairs = Dictionary.load(from_lang, to_lang, dictionaries)
        
        files.each do |source|
          # Read in file and replace matches in content
          content = File.read(source)
          pairs.each do |pair|
            search, replace = pair
            content.gsub! search, replace
          end

          # Write changed content to file
          File.open(Utils.build_converted_file_name(source, from_lang, to_lang), "w") do |file|
            file.puts content
          end
        end
      end
    end
  end
end
