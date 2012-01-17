require "konjac/version"
require "konjac/exception"
autoload :Amatch,    "amatch"
autoload :FileUtils, "fileutils"
autoload :I18n,      "i18n"
autoload :Nokogiri,  "nokogiri"

# Konjac is a Ruby command-line utility for translating files using a YAML
# wordlist
module Konjac
  # Set up autoload for all modules
  autoload :CLI,        "konjac/cli"
  autoload :Config,     "konjac/config"
  autoload :Dictionary, "konjac/dictionary"
  autoload :Language,   "konjac/language"
  autoload :Suggestor,  "konjac/suggestor"
  autoload :Tag,        "konjac/tag"
  autoload :TagManager, "konjac/tag_manager"
  autoload :Translator, "konjac/translator"
  autoload :Utils,      "konjac/utils"
  autoload :Word,       "konjac/word"

  Config.load
end
