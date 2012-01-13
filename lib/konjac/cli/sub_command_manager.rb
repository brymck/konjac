module Konjac
  module CLI
    class SubCommandManager
      def initialize
        @sub_commands ||= []
      end

      def add(name, aliases, description, &block)
        @sub_commands << SubCommand.new(name, aliases, description, &block)
      end

      def execute(sub_command)
        sub_command = sub_command.to_sym

        @sub_commands.each do |sc|
          if sc.name == sub_command || sc.aliases.include?(sub_command)
            sc.execute
            return sc.name
          end
        end

        return nil
      end

      def all
        @sub_commands
      end

      def get_lengths
        @lengths = { :name => 8, :aliases => 7, :description => 11 }

        @sub_commands.each do |sc|
          if sc.name.length > @lengths[:name]
            @lengths[:name] = sc.name.length
          end
          if sc.alias_text.length > @lengths[:aliases]
            @lengths[:aliases] = sc.alias_text.length
          end
          if sc.description.length > @lengths[:description]
            @lengths[:description] = sc.description.length
          end
        end
      end

      def to_s
        get_lengths
        text = "\n"

        header_lines = "%s  %s  %s\n" % [
          "-" * @lengths[:name],
          "-" * @lengths[:aliases],
          "-" * @lengths[:description]
        ]

        # Create headers
        text << header_lines
        text << "%s  %s  %s\n" % [
          "Commands".ljust(@lengths[:name]),
          "Aliases".ljust(@lengths[:aliases]),
          "Description".ljust(@lengths[:description])
        ]
        text << header_lines

        # Write descriptions of each subcommand
        @sub_commands.each do |sc|
          text << "%s  %s  %s\n" % [
            sc.name.to_s.ljust(@lengths[:name]),
            sc.alias_text.to_s.ljust(@lengths[:aliases]),
            sc.description.to_s.ljust(@lengths[:description])
          ]
        end

        text
      end
    end
  end
end
