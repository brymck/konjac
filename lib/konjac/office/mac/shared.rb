# coding: utf-8
require "appscript"

module Konjac
  module Office
    module Mac
      # Inherits from Base and adds some shared methods to the Mac interface 
      class Shared < Base
        # Creates a new Shared object
        def initialize(app_name, path = nil)
          @application  = Appscript.app(app_name)
          super path
          @item_opts.merge!({
            :read  => :get,
            :write => :set
          })
          @shape_opts.merge!({
            :read  => :get,
            :write => :set
          })
        end

        # Open the document at the supplied +path+ using the current application
        def open(path)
          @application.open path
        end

        # Closes the document. If <tt>:saving</tt> is set to +true+ the document
        # will be saved first. If it's set to +false+ the document will not be
        # saved.
        def close(opts = {})
          opts[:saving] = case opts[:saving]
                          when true
                            :yes
                          when false
                            :no
                          else
                            nil
                          end
          @document.close :saving => opts[:saving]
        end
        
        # Retrieves the POSIX path of the document
        def path
          @path ||= posix_path(@document.full_name.get)
        end

        private

        # Converts an HFS (Mac) path to a POSIX path
        def posix_path(hfs_path)
          %x[osascript -e 'POSIX path of "#{hfs_path}"'].chomp
        end

        # Converts a POSIX path to an HFS (Mac) path
        def hfs_path(posix_path)
          %x[osascript -e '(POSIX file "#{posix_path}") as string'].chomp
        end
      end
    end
  end
end
