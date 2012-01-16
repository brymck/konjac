require "term/ansicolor"
require "trollop"
require "yaml"

module Konjac
  module CLI
    class Color
      extend Term::ANSIColor
    end

    class << self
      SUB_COMMANDS = ["add", "edit", "export", "import", "language", "translate"]
      BANNER = <<-eos
#{Color.bold { Color.underscore { "KONJAC" } }}

#{Color.bold "%s"}

#{Color.bold I18n.t :usage}
       konjac %s [#{Color.underscore I18n.t :options}] <#{I18n.t :filenames}>+%s
#{I18n.t(:where_options) % Color.underscore(I18n.t(:options))}
eos

      def start
        ARGV << "-h" if ARGV.empty?
        global_opts = Trollop::options do
          version "konjac #{Konjac::VERSION} (c) 2012 " + I18n.t(:me)
          banner BANNER % [
            I18n.t(:banner),
            "[#{Color.underscore I18n.t :subcommand}]",
            "\n\n" + (I18n.t(:where_subcommand) % Color.underscore(I18n.t(:subcommand))) + ("\n%s\n" %
              Konjac::CLI.describe_subcommands)
          ]
          opt :dry_run, I18n.t(:dry_run, :scope => :opts), :short => "n"
          opt :quiet, I18n.t(:quiet, :scope => :opts)
          opt :version, I18n.t(:version, :scope => :opts)
          opt :help, I18n.t(:help, :scope => :opts)
          stop_on SUB_COMMANDS
        end

        # Get subcommand
        cmd = ARGV.shift
        sc_banner = BANNER % [I18n.t(cmd, :scope => :subcommands), cmd, "\n"]
        cmd_opts = case cmd
          when "add"
            opts = Trollop::options do
              banner sc_banner
              opt :original, I18n.t(:original, :scope => :opts), :type => :string
              opt :translation, I18n.t(:translation, :scope => :opts), :type => :string, :short => :r
              opt :from, I18n.t(:from, :scope => :opts), :type => :string
              opt :to, I18n.t(:to, :scope => :opts), :type => :string
              opt :using, I18n.t(:using, :scope => :opts), :type => :string,
                :default => "dict", :multi => true
              opt :help, I18n.t(:help, :scope => :opts)
            end
            Dictionary.add_word opts
          when "edit"
            Trollop::options do
              banner sc_banner
              opt :editor, I18n.t(:editor, :scope => :opts), :type => :string
              opt :help, I18n.t(:help, :scope => :opts)
            end
            Word.edit_docx_tags ARGV, opts
          when "export"
            opts = Trollop::options do
              banner sc_banner
              opt :from, I18n.t(:from, :scope => :opts), :type => :string
              opt :to, I18n.t(:to, :scope => :opts), :type => :string
              opt :using, I18n.t(:using, :scope => :opts), :type => :string,
                :default => "dict", :multi => true
              opt :help, I18n.t(:help, :scope => :opts)
            end
            Word.export_docx_tags ARGV, opts
          when "import"
            Trollop::options do
              banner sc_banner
              opt :help, I18n.t(:help, :scope => :opts)
            end
            Word.import_docx_tags ARGV
          when "language"
            Trollop::options do
              banner sc_banner
              opt :help, I18n.t(:help, :scope => :opts)
            end
            Config.language = ARGV[0]
            Config.save
          when "translate"
            opts = Trollop::options do
              banner sc_banner
              opt :from, I18n.t(:from, :scope => :opts), :type => :string
              opt :to, I18n.t(:to, :scope => :opts), :type => :string
              opt :using, I18n.t(:using, :scope => :opts), :type => :string,
                :default => "dict", :multi => true
              opt :use_cache, I18n.t(:use_cache, :scope => :opts), :default => false
              opt :word, I18n.t(:word, :scope => :opts), :default => false
              opt :help, I18n.t(:help, :scope => :opts)
            end
            result = translate(ARGV, opts)
            puts result if opts[:word]
          else
            if global_opts[:quiet]
              raise SystemExit
            else
              Trollop::die I18n.t(:unknown_subcommand) % cmd.inspect
            end
        end
      end

      # Describe the subcommands available to the command line interface
      def describe_subcommands
        text = []
        leftcol_width = SUB_COMMANDS.map(&:length).max
        SUB_COMMANDS.each do |sc|
          text << "  %#{leftcol_width}s:   %s" % [sc, I18n.t(sc, :scope => :subcommands)]
        end
        text.join "\n"
      end

      private
      
      def translate(files, opts = {})
        to_lang = Language.find(opts[:to]).to_s

        if opts[:word]
          from_lang = Language.find(opts[:from]).to_s
          Translator.translate_word ARGV[0].dup, from_lang, to_lang, opts
        else
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

          Translator.translate_files parsed_files, from_lang, to_lang, opts
        end
      end
    end
  end
end
