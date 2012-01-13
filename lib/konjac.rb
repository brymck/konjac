require "konjac/version"
require "konjac/exception"
autoload :FileUtils, "fileutils"
autoload :Nokogiri,  "nokogiri"

module Konjac
  # Set up autoload for all modules
  autoload :CLI,        "konjac/cli"
  autoload :Dictionary, "konjac/dictionary"
  autoload :Language,   "konjac/language"
  autoload :Tag,        "konjac/tag"
  autoload :Translator, "konjac/translator"
  autoload :Utils,      "konjac/utils"
  autoload :Word,       "konjac/word"
end
