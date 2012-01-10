module Konjac
  module Translator
    class << self
      def translate(files, from_lang, to_lang)
        pairs = Dictionary.load(from_lang, to_lang)

        files.each do |source|
          # Read in file and replace matches in content
          content = File.read(source)
          pairs.each do |pair|
            content.gsub! pair[0], pair[1]
          end

          # Write changed content to file
          File.open(build_converted_file_name(source), "w") do |file|
            file.puts content
          end
        end
      end

      private

      # Build converted file name by appending "_converted" to the file name
      def build_converted_file_name(source)
        dirname  = File.dirname(source)
        basename = File.basename(source, ".*")
        extname  = File.extname(source)
        
        "#{dirname}/#{basename}_converted#{extname}"
      end
    end
  end
end
