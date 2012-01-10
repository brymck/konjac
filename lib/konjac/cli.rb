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
        from_index = ARGV.index("from")
        to_index = ARGV.index("to")

        # Get the to and from languages and delete them from ARGV
        unless from_index.nil? || to_index.nil?
          if from_index < to_index
            ARGV.delete_at to_index
            to_lang = ARGV.delete_at(to_index)
            ARGV.delete_at from_index
            from_lang = ARGV.delete_at(from_index)
          else
            ARGV.delete_at to_index
            to_lang = ARGV.delete_at(to_index)
            ARGV.delete_at from_index
            from_lang = ARGV.delete_at(from_index)
          end
        else
          puts "You must supply both a to and from language"
          puts "Example: konjac translate foo.txt from english to japanese"
          exit 1
        end

        # Get a list of files to translate
        files = []
        while !ARGV.empty?
          files += Dir.glob(ARGV.shift)
        end
        files.uniq!

        Translator.translate files, from_lang, to_lang
      end
    end
  end
end
