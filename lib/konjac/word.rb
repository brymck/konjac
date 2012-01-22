module Konjac
  # A singleton for dealing with extracting and importing tags from {Microsoft
  # Word}[http://office.microsoft.com/en-us/word/] 2003+ documents
  module Word
    class << self
      # Imports the text content of a tag file into a {Microsoft
      # Word}[http://office.microsoft.com/en-us/word/] 2003+ document
      def import_docx_tags(files)
        sub_files = Utils.parse_files(files, :extension => :docx)
        sub_files.each do |sub_file|
          # Build the list of paths we need to work with
          dirname   = File.dirname(sub_file)
          basename  = File.basename(sub_file, ".*")
          orig_docx = "#{dirname}/#{basename}.docx"
          new_path  = "#{dirname}/#{basename}_imported.docx"
          xml_path  = "#{dirname}/#{basename}.xml"
          tags_path = "#{dirname}/#{basename}.diff"
          out_path  = "#{dirname}/word/document.xml"

          # Open the original XML file and the updated tags
          writer = Nokogiri::XML(File.read(xml_path))
          nodes  = writer.xpath("//w:t")
          tags   = TagManager.new(tags_path)

          # Overwrite each <w:t> tag's content with the new tag
          tags.all.each do |tag|
            if tag.translated?
              nodes[tag.index].content = tag.translated
            end
          end

          # Create a directory for word/document.xml if necessary
          unless File.directory?("#{dirname}/word")
            FileUtils.mkdir "#{dirname}/word"
          end

          # Write the modified XML to a file
          File.open(out_path, "w") do |file|
            file.write writer.to_xml.gsub(/\n\s*/, "").sub(/\?></, "?>\n<")
          end

          # Copy the original file
          FileUtils.cp orig_docx, new_path

          # Add the new document XML to the copied file
          system "cd #{dirname} && zip -q #{new_path} word/document.xml"
        end
      end

      # Exports the text content of {Microsoft
      # Word}[http://office.microsoft.com/en-us/word/] 2003+ document
      def export_docx_tags(files, opts = {})
        # Determine whether to attempt translating
        if opts[:from_given] && opts[:to_given]
          from_lang = Language.find(opts[:from])
          to_lang   = Language.find(opts[:to])
          unless from_lang.nil? || to_lang.nil?
            Translator.load_dictionary from_lang, to_lang, opts
            attempting_to_translate = true
          end
        end

        sub_files = Utils.parse_files(files, :extension => :docx)
        sub_files.each do |sub_file|
          # Build a list of all the paths we're working with
          dirname    = File.dirname(sub_file)
          basename   = File.basename(sub_file, ".*")
          orig_docx  = "#{dirname}/#{basename}.docx"
          xml_path   = "#{dirname}/#{basename}_orig.xml"
          clean_path = "#{dirname}/#{basename}.xml"
          tags_path  = "#{dirname}/#{basename}.diff"

          # Unzip the DOCX's word/document.xml file and pipe the output into
          # an XML with the same base name as the DOCX
          system "unzip -p #{orig_docx} word/document.xml > #{xml_path}"

          # Read in the XML file and extract the content from each <w:t> tag
          cleaner = Nokogiri::XML(File.read(xml_path))
          File.open(tags_path, "w") do |tags_file|
            # Remove all grammar and spellcheck tags
            cleaner.xpath("//w:proofErr").remove

            nodes = cleaner.xpath("//w:r")
            prev = nil
            nodes.each do |node|
              unless prev.nil?
                if (prev.next_sibling == node) && compare_nodes(prev, node)
                  begin
                    node.at_xpath("w:t").content = prev.at_xpath("w:t").content +
                      node.at_xpath("w:t").content
                    prev.remove
                  rescue
                  end
                end
              end
              
              prev = node
            end

            # Write the tags file
            tags_file.puts "---" + orig_docx
            tags_file.puts "+++" + orig_docx
            cleaner.xpath("//w:t").each_with_index do |node, index|
              tags_file.puts "@@ %i @@" % [index, additional_info(node)]
              tags_file.puts "-" + node.content
              if attempting_to_translate
                tags_file.puts "+" + Translator.translate_content(node.content)
              else
                tags_file.puts "+" + node.content
              end
            end
          end

          # Write the cleaned-up XML to a file for inspection
          File.open(clean_path, "w") do |xml|
            xml.puts cleaner.to_xml
          end
        end
      end

      # Opens the .konjac tag files for the specified .docx files
      def edit_docx_tags(files)
        sub_files = Utils.force_extension(files, ".konjac")
        sub_files.each do |sub_file|
          system "$EDITOR #{sub_file}"
        end
      end

      private

      # Performs a comparison between two nodes and accepts them as equivalent
      # if the differences are very minor
      def compare_nodes(a, b)  # :doc:
        c = clean_hash(xml_node_to_hash(a))
        d = clean_hash(xml_node_to_hash(b))
        c == d
      end

      # Converts an XML node into a Ruby hash
      def xml_node_to_hash(node)  # :doc:
        # If we are at the root of the document, start the hash
        if node.element?
          result_hash = {}
          if node.attributes != {}
            result_hash[:attributes] = {}
            node.attributes.keys.each do |key|
              result_hash[:attributes][node.attributes[key].name.to_sym] = prepare(node.attributes[key].value)
            end
          end
          if node.children.size > 0
            node.children.each do |child|
              result = xml_node_to_hash(child)

              if child.name == "text"
                unless child.next_sibling || child.previous_sibling
                  return prepare(result)
                end
              elsif result_hash[child.name.to_sym]
                if result_hash[child.name.to_sym].is_a?(Array)
                  result_hash[child.name.to_sym] << prepare(result)
                else
                  result_hash[child.name.to_sym] = [result_hash[child.name.to_sym]] << prepare(result)
                end
              else
                result_hash[child.name.to_sym] = prepare(result)
              end
            end

            return result_hash
          else
            return result_hash
          end
        else
          return prepare(node.content.to_s)
        end
      end

      # Prepares data according to whether it's string or integer content
      def prepare(data)  # :doc:
        (data.class == String && data.to_i.to_s == data) ? data.to_i : data
      end

      # Delete extraneous attributes for comparison
      def clean_hash(hash)  # :doc:
        delete_attribute_or_child hash, :t
        delete_attribute_or_child hash, :rPr, :rFonts, :attributes, :hint
      end

      # Get additional information on the node for context in tags file
      def additional_info(node)  # :doc:
        info = []
        info << "hyperlink" if node.parent.parent.name == "hyperlink"

        if info.empty?
          ""
        else
          "  #=> #{info.join(", ")}"
        end
      end

      # Deletes the specified attribute or child node for the supplied node,
      # following the hierarchy provided
      #
      # Delete <tt>hash[:rPr][:rFonts][:attributes][:hint]</tt>:
      #   delete_attribute_or_child hash, :rPr, :rFonts, :attributes, :hint
      def delete_attribute_or_child(node, *hierarchy)  # :doc:
        last_member = hierarchy.pop
        
        hierarchy.each do |member|
          node = node[member] unless node.nil?
        end

        node.delete last_member unless node.nil?
      end
    end
  end
end
