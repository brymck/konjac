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
  module Office
    autoload :Generic,   "konjac/office/generic"
    autoload :Mac,       "konjac/office/mac"
    autoload :OS,        "konjac/office/os"
    autoload :Tag,       "konjac/office/tag"
    autoload :Windows,   "konjac/office/windows"
    autoload :XML,       "konjac/office/windows"

    class << self
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

      def camelize(lower_case_and_underscored_word, first_letter_in_uppercase = true)
        if first_letter_in_uppercase
          lower_case_and_underscored_word.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
        else
          lower_case_and_underscored_word.to_s[0].chr.downcase + camelize(lower_case_and_underscored_word)[1..-1]
        end
      end

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
