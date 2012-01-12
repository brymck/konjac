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
            dirname   = File.dirname(sub_file)
            basename  = File.basename(sub_file, ".*")
            xml_path  = "#{dirname}/#{basename}.xml"
            tags_path = "#{dirname}/#{basename}.tags"

            # Unzip the DOCX's word/document.xml file and pipe the output into
            # an XML with the same base name as the DOCX
            system "unzip -p #{sub_file} word/document.xml > #{xml_path}"

            # Read in the XML file and extract the content from each <w:t> tag
            reader = Nokogiri::XML(File.read(xml_path))
            File.open(tags_path, "w") do |tags_file|
              reader.xpath("//w:t").each do |node|
                tags_file.puts node.content
              end
            end
          end
        end
      end
    end
  end
end
# lol
