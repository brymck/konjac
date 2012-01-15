require "term/ansicolor"
require "trollop"

module Konjac
  module CLI
    class Color
      extend Term::ANSIColor
    end

    class << self
      SUB_COMMANDS = {
        "edit"      => "Edit the tags file for a .docx file",
        "export"    => "Export text tags from a .docx file",
        "import"    => "Import text tags into a .docx file",
        "translate" => "Translate a file according to ~/.konjac/dict.yml"
      }
      BANNER = <<-eos
#{Color.bold "%s"}

#{Color.bold "Usage:"}
       konjac %s [#{Color.underscore "options"}] <filenames>+%s
where [#{Color.underscore "options"}] are:
eos

      def start
        global_opts = Trollop::options do
          version "konjac #{Konjac::VERSION} (c) 2012 Bryan McKelvey"
          banner BANNER % [
            "konjac is a Ruby command-line utility for translating files " +
              "using a YAML wordlist",
            "[#{Color.underscore "subcommand"}]",
            "\n\nwhere [#{Color.underscore "subcommand"}] is any one of:\n%s\n" %
              Konjac::CLI.describe_subcommands
          ]
          opt :dry_run, "Don't actually do anything", :short => "n"
          opt :quiet, "Suppress error messages"
          stop_on SUB_COMMANDS.keys
        end

        # Get subcommand
        cmd = ARGV.shift
        sc_banner = BANNER % [SUB_COMMANDS[cmd], cmd, ""]
        cmd_opts = case cmd
          when "edit"
            Trollop::options do
              banner sc_banner
              opt :editor, "A command indicating which editor to use (e.g. vi %s)"
            end
            Word.edit_docx_tags ARGV, opts
          when "extract", "export"
            Trollop::options do
              banner sc_banner
            end
            Word.extract_docx_tags ARGV
          when "import"
            Trollop::options do
              banner sc_banner
            end
            Word.import_docx_tags ARGV
          when "translate"
            opts = Trollop::options do
              banner sc_banner
              opt :from, "The language from which to translate", :type => :string
              opt :to, "The language into which to translate", :type => :string
              opt :using, "The names of dictionaries to use", :type => :string,
                :default => "dict", :multi => true
            end
            translate ARGV, opts
          else
            Trollop::die "unknown subcommand #{cmd.inspect}"
        end
      end

      # Describe the subcommands available to the command line interface
      def describe_subcommands
        text = []
        leftcol_width = SUB_COMMANDS.keys.map(&:length).max
        SUB_COMMANDS.each do |sc, desc|
          text << "  %#{leftcol_width}s:   %s" % [sc, desc]
        end
        text.join "\n"
      end

      private
      
      def translate(files, opts = {})
        # Get a list of files to translate
        parsed_files = Utils.parse_files(files)
        raise FileNotFoundError.new("File not found") if parsed_files.empty?

        # Determine from language from first filename if not supplied
        if opts[:from].nil?
          opts[:from] = Utils.extract_language_code_from_filename(parsed_files[0])
          if opts[:from].nil?
            raise InvalidLanguageError.new("You must supply a from language")
          end
        end

        from_lang = Language.find(opts[:from]).to_s
        to_lang   = Language.find(opts[:to]).to_s
        puts "adlfjlaksdjfkjsdlfjdks"
        puts parsed_files
        puts from_lang
        puts to_lang

        Translator.translate parsed_files, from_lang, to_lang, opts[:using]
      end
    end
  end
end
