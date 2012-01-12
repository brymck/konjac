require "konjac/version"
autoload :FileUtils, "fileutils"

module Konjac
  # Set up autoload for all modules
  autoload :CLI,        "konjac/cli"
  autoload :Dictionary, "konjac/dictionary"
  autoload :Exceptions, "konjac/exceptions"
  autoload :Languages,  "konjac/languages"
  autoload :Translator, "konjac/translator"
end
