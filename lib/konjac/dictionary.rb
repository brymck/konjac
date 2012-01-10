module Konjac
  module Dictionary
    class << self
      def load
        dict_dir = File.expand_path("~/.konjac/")
        dict_path = dict_dir + "/dict.yml"

        unless File.file?(dict_path)
          FileUtils.mkpath dict_dir
          FileUtils.touch dict_path
        end

        @dictionary = YAML.load_file(dict_path)
        puts @dictionary
      end
    end
  end
end
