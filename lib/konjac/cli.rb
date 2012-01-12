module Konjac
  module CLI
    class << self
      def start
        show_help if ARGV.empty?

        # Subcommand
        case ARGV.shift
        when "translate"
          translate
        when "add"
        when "help"
          show_help
        else
          raise ArgumentError.new("Valid commands are translate or add")
        end
      end

      def show_help
        puts "Help"
        exit 0
      end

      private

      def translate
        # Get from language
        from_index = ARGV.index("from")
        unless from_index.nil?
          ARGV.delete_at from_index
          from_lang = ARGV.delete_at(from_index)
        end
        
        # Get to language
        to_index = ARGV.index("to") || ARGV.index("into")
        if to_index.nil?
          raise Exception::InvalidLanguageError.new("You must supply a to language")
        else
          ARGV.delete_at to_index
          to_lang = ARGV.delete_at(to_index)
        end

        # Get a list of files to translate
        files = []
        while !ARGV.empty?
          files += Dir.glob(File.expand_path(ARGV.shift))
        end
        raise Exception::FileNotFoundError.new("File not found") if files.empty?
        files.uniq!

        # Determine from language from first filename if not overridden
        if from_lang.nil?
          from_lang = Utils.extract_language_code_from_filename(files[0])
          if from_lang.nil?
            raise Exception::InvalidLanguageError.new("You must supply a to language")
          end
        end

        from_lang = Language.find(from_lang).to_s
        to_lang   = Language.find(to_lang).to_s

        Translator.translate files, from_lang, to_lang
      end
    end
  end
end
