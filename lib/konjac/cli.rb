module Konjac
  module CLI
    autoload :SubCommand,        "konjac/cli/sub_command"
    autoload :SubCommandManager, "konjac/cli/sub_command_manager"

    class << self
      def init_sub_commands
        @valid_commands = SubCommandManager.new
        @valid_commands.add :edit, [:e], "Edit text extracted from DOCX" do
          Word.edit_docx_tags(ARGV)
        end
        @valid_commands.add :extract, [:export, :x], "Extract text from a DOCX file" do
          Word.extract_docx_tags(ARGV)
        end
        @valid_commands.add :help, [:h, :"?"], "Show help" do
          show_help
        end
        @valid_commands.add :import, [:m], "Import text back into a DOCX file" do
          Word.import_docx_tags(ARGV)
        end
        @valid_commands.add :translate, [:t], "Translate a file" do
          translate
        end
      end

      def start
        init_sub_commands
        show_help if ARGV.empty?

        # Subcommand
        sub_command = ARGV.shift
        result = @valid_commands.execute(sub_command)

        if result.nil?
          raise InvalidCommandError.new("#{@valid_commands.to_s}\n\nInvalid subcommand: #{sub_command}")
        end

        result
      end

      def show_help
        puts @valid_commands.to_s
      end

      private

      def translate
        # Get dictionaries
        using_index = ARGV.index("using")
        unless using_index.nil?
          ARGV.delete_at using_index
          dictionaries = []
          while ARGV.length > using_index && !["from", "to", "into"].include?(ARGV[using_index])
            dictionaries << ARGV.delete_at(using_index)
          end
        end
        
        # Get from language
        from_index = ARGV.index("from")
        unless from_index.nil?
          ARGV.delete_at from_index
          from_lang = ARGV.delete_at(from_index)
        end
        
        # Get to language
        to_index = ARGV.index("to") || ARGV.index("into")
        if to_index.nil?
          raise InvalidLanguageError.new("You must supply a to language")
        else
          ARGV.delete_at to_index
          to_lang = ARGV.delete_at(to_index)
        end

        # Get a list of files to translate
        files = []
        while !ARGV.empty?
          files += Dir.glob(File.expand_path(ARGV.shift))
        end
        raise FileNotFoundError.new("File not found") if files.empty?
        files.uniq!

        # Determine from language from first filename if not overridden
        if from_lang.nil?
          from_lang = Utils.extract_language_code_from_filename(files[0])
          if from_lang.nil?
            raise InvalidLanguageError.new("You must supply a to language")
          end
        end

        from_lang = Language.find(from_lang).to_s
        to_lang   = Language.find(to_lang).to_s

        Translator.translate files, from_lang, to_lang, dictionaries
      end
    end
  end
end
