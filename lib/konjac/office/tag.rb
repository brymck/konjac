# coding: utf-8
module Konjac
  module Office
    # A tag item, used to export and import data to and from the document
    class Tag
      # The indices used to scan the document's hierarchy to reach the item
      attr_accessor :indices
      
      # The text that has been removed
      attr_accessor :removed
      
      # The text with which to replaced the removed content
      attr_accessor :added
      
      # The type, used to identify special objects such as a
      # <tt>:shape</tt>. Defaults to +nil+.
      attr_accessor :type

      # Creates a new tag item
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
        # A list of regular expressions for parsing a document in unified
        # diff-esque style into Tags
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

        # Dumps the tags into a .diff document with the same name as the
        # document from which those tags were extracted
        def dump(tags, path, opts = {})
          original_path = path.sub(/\.diff$/, "")
          diff_path     = "#{original_path}.diff"
          
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
