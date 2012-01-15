module Konjac
  module Utils
    class << self
      # Extracts the two letter language code from a filename
      def extract_language_code_from_filename(name)
        match = File.basename(name, ".*").match(/_([a-z]{2})/i)

        if match.nil?
          nil
        else
          match[1]
        end
      end

      # Build converted file name by appending "_converted" to the file name
      def build_converted_file_name(source, from_lang, to_lang)
        # Get components of filename
        dirname  = File.dirname(source)
        basename = File.basename(source, ".*")
        extname  = File.extname(source)

        # Blank out the from language
        basename.sub! Regexp.new("_#{from_lang}", "i"), ""
        
        "#{dirname}/#{basename}_#{to_lang}#{extname}"
      end
      
      # Parses a list of files
      def parse_files(files, ext = nil)
        files = [files] unless files.is_a?(Array)
        parsed_files = []
        while !files.empty?
          file = files.shift
          file = file.sub(/\.[^\\\/]*$/, "") + ext unless ext.nil?
          parsed_files += Dir.glob(File.expand_path(file))
        end
        parsed_files.uniq
      end
    end
  end
end
