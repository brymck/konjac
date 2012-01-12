module Konjac
  module Word
    class << self
      # Extracts the text content from a Microsoft Word 2003+ Document
      def import_docx_tags(files)
        files.each do |file|
          sub_files = Dir.glob(File.expand_path(file))
          sub_files.each do |sub_file|
            dirname   = File.dirname(sub_file)
            basename  = File.basename(sub_file, ".*")
            xml_path  = "#{dirname}/#{basename}.xml"
            tags_path = "#{dirname}/#{basename}.tags"

            reader = Nokogiri::XML::Reader(File.read(xml_path))
            File.open(tags_path, "w") do |tags_file|
              reader.each do |node|
                if node.name == "#text"
                  tags_file.puts node.value
                end
              end
            end
          end
        end
      end

      # Extracts the text content from a Microsoft Word 2003+ Document
      def extract_docx_tags(files)
        files.each do |file|
          sub_files = Dir.glob(File.expand_path(file))
          sub_files.each do |sub_file|
            dirname   = File.dirname(sub_file)
            basename  = File.basename(sub_file, ".*")
            xml_path  = "#{dirname}/#{basename}.xml"
            tags_path = "#{dirname}/#{basename}.tags"

            system "unzip -p #{sub_file} word/document.xml > #{xml_path}"

            reader = Nokogiri::XML::Reader(File.read(xml_path))
            File.open(tags_path, "w") do |tags_file|
              reader.each do |node|
                if node.name == "#text"
                  tags_file.puts node.value
                end
              end
            end
          end
        end
      end
    end
  end
end
# lol
