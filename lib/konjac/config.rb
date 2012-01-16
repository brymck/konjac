require "i18n"
require "yaml"

module Konjac
  # User settings
  module Config
    class << self
      # The path to the user's configuration file
      CONFIG_PATH = File.expand_path("~/.konjac/config.yml")

      # Loads the user's settings
      def load
        Utils.verify_file CONFIG_PATH, "--- {}"
        config = YAML.load_file(CONFIG_PATH)
        config = {} unless config.is_a?(Hash)

        set_language config[:language], ENV["LANG"], :en
        save
      end

      # The current interface language
      def language
        I18n.locale
      end

      # Sets the language to use for the interface. Note that this has no
      # effect in determining the to or from languages to use for translation
      def language=(lang)
        set_language lang, I18n.locale
        save
      end

      # Saves the user configurations
      def save
        File.open(CONFIG_PATH, "w") do |file|
          YAML.dump @opts, file
        end
      end

      private

      # Calculates the language based on the available languages in the gem
      # locale files versus the supplied parameters, in order. Suggested backup
      # parameters are the system language (<tt>ENV["LANG"]</tt>), the current
      # locale (<tt>I18n.locale</tt>), the default locale
      # (<tt>I18n.default_locale</tt>), etc.
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
