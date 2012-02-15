module Konjac
  # A singleton for dealing with extracting and importing tags from Microsoft
  # Office documents. It also has abstract some of the lengthier calls to the
  # different applications of different environments by detecting the user's
  # operating system and using ghost methods. For example, the following are
  # equivalent for opening the document at <tt>~/text.doc</tt> on a Mac:
  #
  #   doc = Konjac::Office::Mac::Word.new("~/text.doc")
  #   doc = Konjac::Office.word("~/text.doc")
  #
  # In addition, if the document is already open and is the active document, the
  # following will work too:
  #
  #   doc = Konjac::Office.word
  #
  # From there, you can send some basic reading and writing instructions to the
  # document:
  #
  #   doc.read 1
  #   doc.read :paragraph => 1
  #   doc.read 1, :type => :shape
  #
  #   doc.write "First paragraph", 1
  #
  #   doc.export
  #   doc.import
  module Office
    autoload :Base,    "konjac/office/base"
    autoload :Mac,     "konjac/office/mac"
    autoload :OS,      "konjac/office/os"
    autoload :Tag,     "konjac/office/tag"
    autoload :Windows, "konjac/office/windows"
    autoload :XML,     "konjac/office/windows"

    class << self
      # Creates a new object inheriting from Base. The application chosen is
      # based on the user's environment and the type of the document. For
      # example, a file with a .docx extension will default to Microsoft Word,
      # and on OSX it will default to Konjac::Office::Mac::Word
      def new(path)
        env = environment
        return nil if env.nil?

        case File.basename(path)
        when /\.docx?/
          env::Word.new(path)
        when /\.pptx?/
          env::PowerPoint.new(path)
        when /\.xlsx?/
          env::Excel.new(path)
        end
      end

      # The user's environment. Currently, this just detects whether an OS is
      # Windows, Mac or other (simply because Microsoft Office is unavailable
      # on Linux, so scripting something like LibreOffice or OpenOffice is more
      # long-term).
      def environment
        if OS.mac?
          Mac
        elsif OS.windows?
          Windows
        else
          nil 
        end
      end

      private

      # If possible, retrieves the appropriate class inheriting from Office::Base for the user
      # based on his environment or OS. For example, if a user types
      #
      #   doc = Konjac::Office.word
      #
      # on Mac that will be the same thing as a call to
      #
      #   doc = Konjac::Mac::Office.new
      #
      # whereas for a user on Windows it will be equivalent to
      #
      #   doc = Konjac::Windows::Office.new
      def method_missing(name, *args, &block)
        env = environment
        return super if env.nil?
        index = env.constants.index(camelize(name).to_sym)
        if index.nil?
          super
        else
          env.const_get(env.constants[index]).new *args
        end
      end

      # A list of valid environments based on the directories in the
      # lib/konjac/office folder of this gem
      def valid_environments
        return @environments unless @environments.nil?

        @environments = []
        downcased = constants.map { |c| underscore(c.to_s) }
        Dir.glob(File.join(File.dirname(File.expand_path(__FILE__)), "office/*/")).each do |dir|
          index = downcased.index(dir.split("/").last)
          @environments << constants[index] unless index.nil?
        end

        @environments
      end

      # Converts snake_case into CamelCase
      def camelize(lower_case_and_underscored_word, first_letter_in_uppercase = true)
        if first_letter_in_uppercase
          lower_case_and_underscored_word.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
        else
          lower_case_and_underscored_word.to_s[0].chr.downcase + camelize(lower_case_and_underscored_word)[1..-1]
        end
      end

      # Converts CamelCase into snake_case
      def underscore(camel_cased_word)
        camel_cased_word.to_s.gsub(/::/, '/').
          gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
          gsub(/([a-z\d])([A-Z])/,'\1_\2').
          tr("-", "_").
          downcase
      end
    end
  end
end
