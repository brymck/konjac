module Konjac
  module Word
    class << self
      # Extracts the text content from a Microsoft Word 2003+ Document
      def import_docx_tags(files)
        files.each do |file|
          sub_files = Dir.glob(File.expand_path(file))
          sub_files.each do |sub_file|
            # Build the list of paths we need to work with
            dirname   = File.dirname(sub_file)
            basename  = File.basename(sub_file, ".*")
            new_path  = "#{dirname}/#{basename}_imported.docx"
            xml_path  = "#{dirname}/#{basename}.xml"
            tags_path = "#{dirname}/#{basename}.tags"
            out_path  = "#{dirname}/word/document.xml"

            # Open the original XML file and the updated tags
            writer = Nokogiri::XML(File.read(xml_path))
            tags   = File.readlines(tags_path)

            # Overwrite each <w:t> tag's content with the new tag
            writer.xpath("//w:t").each do |node|
              node.content = tags.shift.tr("\n", "")
            end

            # Create a directory for word/document.xml if necessary
            FileUtils.mkdir "#{dirname}/word" unless File.directory?("#{dirname}/word")

            # Write the modified XML to a file
            File.open(out_path, "w") do |file|
              file.write writer.to_xml.gsub(/\n\s*/, "").sub(/\?></, "?>\n<")
            end

            # Copy the original file
            FileUtils.cp sub_file, new_path

            # Add the new document XML to the copied file
            system "cd #{dirname} && zip -q #{new_path} word/document.xml"
          end
        end
      end

      # Extracts the text content from a Microsoft Word 2003+ Document
      def extract_docx_tags(files)
        files.each do |file|
          sub_files = Dir.glob(File.expand_path(file))
          sub_files.each do |sub_file|
            # Build a list of all the paths we're working with
            dirname    = File.dirname(sub_file)
            basename   = File.basename(sub_file, ".*")
            xml_path   = "#{dirname}/#{basename}_orig.xml"
            clean_path = "#{dirname}/#{basename}.xml"
            tags_path  = "#{dirname}/#{basename}.tags"

            # Unzip the DOCX's word/document.xml file and pipe the output into
            # an XML with the same base name as the DOCX
            system "unzip -p #{sub_file} word/document.xml > #{xml_path}"

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

              cleaner.xpath("//w:t").each do |node|
                tags_file.puts node.content
              end
            end

            File.open(clean_path, "w") do |xml|
              xml.puts cleaner.to_xml
            end
          end
        end
      end

      private

      # Performs a comparison between two nodes and accepts them as equivalent
      # if the differences are very minor
      def compare_nodes(a, b)
        c = clean_hash(xml_node_to_hash(a))
        d = clean_hash(xml_node_to_hash(b))
        c == d
      end

      def xml_node_to_hash(node)
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

      def prepare(data)
        (data.class == String && data.to_i.to_s == data) ? data.to_i : data
      end

      # Delete extraneous attributes for comparison
      def clean_hash(hash)
        hash.delete :t
        hash[:rPr][:rFonts][:attributes].delete :hint
      end
    end
  end
end
