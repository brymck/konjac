# coding: utf-8
module Konjac
  module Office
    class Tag
      attr_accessor :indices, :removed, :added

      def initialize
        @indices = nil
        @removed = []
        @added   = []
      end

      def changed?
        @removed != @added
      end

      def blank?
        @indices.nil? || (@removed.join.empty? && @added.join.empty?)
      end

      def to_s
        "@@ #{@indices.join(",")} @@\n-#{@removed.join("\n-")}\n+#{@added.join("\n+")}"
      end

      class << self
        TAG_MATCHES = {
          :header  => /^(?:---|\+\+\+)/,
          :comment => /^\@\@[^@]+\@\@$/,
          :removed => /^-(.*)/,
          :added   => /^\+(.*)/,
        }

        # Loads the tags for the specified document path or the tags file itself
        def load(path)
          tags = []
          temp = Tag.new
          File.read("#{path.sub(/\.diff$/, "")}.diff").each_line do |line|
            case line
            when TAG_MATCHES[:header]
            when TAG_MATCHES[:comment]
              unless temp.blank?
                tags << temp
                temp = Tag.new
              end
              temp.indices = line.scan(/\d+/).map(&:to_i)
            when TAG_MATCHES[:removed]
              temp.removed << $1
            when TAG_MATCHES[:added]
              temp.added << $1
            end
          end
          tags << temp unless temp.blank?
          tags
        end

        def dump(tags, path)
          original_path = path.sub(/\.diff$/, "")
          File.open("#{original_path}.diff", "w") do |file|
            file.puts "--- #{original_path}"
            file.puts "+++ #{original_path}"
            tags.each do |tag|
              file.puts tag.to_s
            end
          end
        end
      end
    end
  end
end
