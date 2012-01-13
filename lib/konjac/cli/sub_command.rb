module Konjac
  module CLI
    class SubCommand
      attr :name, :aliases, :description

      def initialize(name, aliases, description, &block)
        @name, @aliases, @description = name, aliases, description
        @block = block
      end

      def alias_text
        @aliases.join ", "
      end

      def execute
        @block.call
      end
    end
  end
end
