# coding: utf-8
module Konjac
  module Office
    # The Office for Windows namespace
    module Windows
      autoload :Excel,      "konjac/office/windows/excel"
      autoload :PowerPoint, "konjac/office/windows/power_point"
      autoload :Shared,     "konjac/office/windows/shared"
      autoload :Word,       "konjac/office/windows/word"
    end
  end
end
