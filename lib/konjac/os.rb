module Konjac
  # A module for determining what OS we're using
  module OS
    class << self
      # Override string output
      def to_s
        RbConfig::CONFIG["host_os"]
      end

      # OS is a version of Mac
      def mac?
        @mac ||= is? /mac|darwin/
      end
      
      # OS is a version of Linux
      def linux?
        @linux ||= is? /linux|cygwin/
      end

      # OS is a version of Windows
      def windows?
        @windows ||= is? /mswin|^win|mingw/
      end

      # OS is POSIX (well, actually, this makes the somewhat bad assumption
      # that non-Windows OSes are POSIX)
      def posix?
        !windows?
      end

      # Throws a message if the computer is using a command restricted to Macs
      def not_a_mac
        if mac?
          return false
        else
          puts I18n.t(:mac_only)
          return true
        end
      end


      private

      # Test whether the +host_os+ configuration parameter matches a specified
      # regular expression
      def is?(match)
        match === RbConfig::CONFIG["host_os"]
      end
    end
  end
end
