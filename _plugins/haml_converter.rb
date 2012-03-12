module Jekyll
  require 'haml'
  require 'sass'

  class HamlConverter < Converter
    safe true
    priority :low

    def matches(ext)
      ext =~ /haml/i
    end

    def output_ext(ext)
      ""
    end

    def convert(content)
      Haml::Engine.new(content).render
    rescue StandardError => e
      puts "HAML error: #{e.message}"
    end
  end

  class SassConverter < Converter
    safe true
    priority :low

    def matches(ext)
      ext =~ /sass/i
    end

    def output_ext(ext)
      ""
    end

    def convert(content)
      Sass::Engine.new(content).render
    rescue StandardError => e
      puts "SASS error: #{e.message}"
    end
  end
end
