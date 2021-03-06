require "konjac/version"
require "konjac/exception"
autoload :Amatch,    "amatch"
autoload :FileUtils, "fileutils"
autoload :Git,       "git"
autoload :HighLine,  "highline/system_extensions"
autoload :I18n,      "i18n"
autoload :Nokogiri,  "nokogiri"
autoload :Tempfile,  "tempfile"

# Konjac is a Ruby command-line utility for translating files using a YAML
# wordlist
module Konjac
  # Set up autoload for all modules
  autoload :CLI,        "konjac/cli"
  autoload :Config,     "konjac/config"
  autoload :Dictionary, "konjac/dictionary"
  autoload :Installer,  "konjac/installer"
  autoload :Language,   "konjac/language"
  autoload :Office,     "konjac/office"
  autoload :Suggestor,  "konjac/suggestor"
  autoload :Translator, "konjac/translator"
  autoload :Utils,      "konjac/utils"

  Config.load
end
