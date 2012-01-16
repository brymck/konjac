require "yaml"

module Konjac
  module Config
    class << self
      CONFIG_PATH = File.expand_path("~/.konjac/config.yml")

      def load
        Utils.verify_file CONFIG_PATH, "--- {}"
        config = YAML.load_file(CONFIG_PATH)
        config = {} unless config.is_a?(Hash)
        @opts = {
          :language => :en
        }.merge config

        set_language
        save
      end

      def language
        @opts[:language]
      end

      def language=(lang)
        @opts[:language] = Language.find(lang).to_sym || @opts[:language]
        save
      end

      def save
        File.open(CONFIG_PATH, "w") do |file|
          YAML.dump @opts, file
        end
      end

      private

      def set_language
        I18n.load_path = Dir[File.join(File.dirname(__FILE__), "..", "..", "locales", "*.yml")]
        I18n.default_locale = :en
        if I18n.available_locales.include?(@opts[:language])
          I18n.locale = @opts[:language]
        else
          I18n.locale = I18n.default_locale
        end
      end
    end
  end
end
