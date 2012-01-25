module Konjac
  # A handful of functions and tools with no other home, primarily for
  # manipulating file names and paths
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

      # Prompts user whether to overwrite the specified file. Passing
      # <tt>:force => true</tt> after the filename will cause this message to
      # be ignored and always return +true+
      def user_allows_overwrite?(file, opts = {})
        if File.exist?(File.expand_path(file)) && !opts[:force]
          print I18n.t(:overwrite) % file
          answer = HighLine::SystemExtensions.get_character.chr
          puts answer
          return answer =~ /^y/i
        else
          return true
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
      def parse_files(files, opts = {})
        opts = { :extension => nil, :directory => nil }.merge opts
        files = [files] unless files.is_a?(Array)
        parsed_files = []
        while !files.empty?
          file = files.shift
          unless opts[:directory].nil?
            file = opts[:directory] + "/" + file
          end
          unless opts[:extension].nil?
            file = file.sub(/\.[^\\\/]*$/, "") + "." + opts[:extension].to_s.tr(".", "")
          end
          parsed_files += Dir.glob(File.expand_path(file))
        end
        parsed_files.uniq
      end

      # Verifies that a file exists, writing initial content to it if not
      def verify_file(path, initial_content = "")
        unless File.exists?(path)
          FileUtils.mkdir_p File.dirname(path)
          File.open(path, "w") do |file|
            file.puts initial_content
          end
        end
      end
    end
  end
end
