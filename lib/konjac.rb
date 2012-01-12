require "konjac/version"
autoload :FileUtils, "fileutils"

module Konjac
  # Set up autoload for all modules
  autoload :CLI,        "konjac/cli"
  autoload :Dictionary, "konjac/dictionary"
  autoload :Exception,  "konjac/exception"
  autoload :Language,   "konjac/language"
  autoload :Translator, "konjac/translator"
  autoload :Utils,      "konjac/utils"
end
