require "yaml"

module Konjac
  module Dictionary
    class << self
      def load(from_lang, to_lang, opts = {})
        opts = { :force => false }.merge(opts)
        return @pairs if loaded? && !opts[:force]

        dict_dir = File.expand_path("~/.konjac/")
        dict_path = dict_dir + "/dict.yml"

        unless File.file?(dict_path)
          FileUtils.mkpath dict_dir
          FileUtils.touch dict_path
        end

        @dictionary = ::YAML.load_file(dict_path)
        @pairs = []

        @dictionary.each do |term|
          if term.has_key?(from_lang) && term.has_key?(to_lang)
            @pairs << [term[from_lang], term[to_lang]]
          end
        end

        @loaded = true
        @pairs
      end

      private

      def loaded?
        !!@loaded
      end
    end
  end
end
