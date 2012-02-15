# coding: utf-8
module Konjac
  module Office
    # The Office for Mac namespace
    module Mac
      autoload :Excel,      "konjac/office/mac/excel"
      autoload :PowerPoint, "konjac/office/mac/power_point"
      autoload :Shared,     "konjac/office/mac/shared"
      autoload :Word,       "konjac/office/mac/word"
    end
  end
end
