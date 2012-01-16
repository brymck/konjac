require "i18n"
require "yaml"

module Konjac
  module Config
    class << self
      CONFIG_PATH = File.expand_path("~/.konjac/config.yml")

      def load
        Utils.verify_file CONFIG_PATH, "--- {}"
        config = YAML.load_file(CONFIG_PATH)
        config = {} unless config.is_a?(Hash)

        set_language config[:language], ENV["LANG"], :en
        save
      end

      def language
        I18n.locale
      end

      def language=(lang)
        set_language lang, I18n.locale
        save
      end

      def save
        File.open(CONFIG_PATH, "w") do |file|
          YAML.dump @opts, file
        end
      end

      private

      def set_language(*params)
        I18n.load_path = Dir[File.join(File.dirname(__FILE__), "..", "..", "locales", "*.yml")]
        I18n.default_locale = :en

        # Check each parameter to see whether it matches with an available
        # language
        params.each do |param|
          if !param.nil?
            lang = Language.find(param).to_sym rescue nil
            if I18n.available_locales.include?(lang)
              I18n.locale = lang
              return I18n.locale
            end
          end
        end

        I18n.locale = I18n.default_locale
      end
    end
  end
end
