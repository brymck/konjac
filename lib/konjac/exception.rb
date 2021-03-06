module Konjac
  # Konjac was unable to find an applicable file
  class FileNotFoundError < StandardError; end

  # The user has supplied an invalid language and Konjac can't continue to
  # process the request
  class InvalidLanguageError < StandardError; end

  # The user has requested an unimplemented virtual method
  class VirtualMethodError < StandardError; end
end
