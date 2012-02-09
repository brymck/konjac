require "appscript"

module Konjac
  module Office
    module Mac
      class Shared < Generic
        def open(path)
          @application.open(path)
        end
      end
    end
  end
end
