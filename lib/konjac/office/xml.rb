# coding: utf-8
module Konjac
  module Office
    # The XML (Open Office XML, that is) namespace
    module XML
      autoload :Excel,      "konjac/office/xml/excel"
      autoload :PowerPoint, "konjac/office/xml/powerpoint"
      autoload :Shared,     "konjac/office/xml/shared"
      autoload :Word,       "konjac/office/xml/word"
    end
  end
end
