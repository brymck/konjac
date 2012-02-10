# coding: utf-8
module Konjac
  module Office
    class Tag
      attr_accessor :indices, :removed, :added, :type

      def initialize
        @indices = nil
        @removed = []
        @added   = []
        @type    = nil
      end

      # Whether the tag has changed content
      def changed?
        @removed != @added
      end

      # Determines whether the tag is blank, that is, if it has no +indices+ or
      # both +removed+ and +added+ are empty
      def blank?
        @indices.nil? || (@removed.join.empty? && @added.join.empty?)
      end

      # Converts the tag to a string
      def to_s
        <<-eos
@@ #{@type.nil? ? "" : "#{@type} "}#{@indices.join(",")} @@
-#{@removed.join("\n-")}
+#{@added.join("\n+")}
        eos
      end

      # Whether the tag's content if for the default kind of object
      def default?
        @type.nil?
      end

      # Whether the tag's content if for a special kind of object
      def special?
        !!@type
      end

      class << self
        TAG_MATCHES = {
          :header  => /^(?:---|\+\+\+)/,
          :comment => /^\@\@ ([a-z]*) ?([\d, ]+) \@\@$/i,
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
              temp.type    = $1.to_sym unless $1.nil?
              temp.indices = $2.scan(/\d+/).map(&:to_i)  # this changes $~
            when TAG_MATCHES[:removed]
              temp.removed << $1
            when TAG_MATCHES[:added]
              temp.added << $1
            end
          end
          tags << temp unless temp.blank?
          tags
        end

        def dump(tags, path, opts = {})
          original_path = path.sub(/\.diff$/, "")
          diff_path     = "#{original_path}.diff"
          
          if File.exist?(diff_path) && !opts[:force]
            File.open(diff_path, "w") do |file|
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
end
