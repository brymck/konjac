$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])
require "konjac"
include Konjac

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
end
