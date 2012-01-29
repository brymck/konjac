# coding: utf-8
module Konjac
  # A class to help with installing supplementary tools for Konjac
  module Installer
    VIM_GIT = "git://github.com/brymck/konjac_vim.git"
    YML_GIT = "git://github.com/brymck/konjac_yml.git"

    class << self
      # Install the supplementary {Vim plugin}[https://github.com/brymck/konjac_vim]
      def install_vim
        if has_pathogen?
          return update_vim if vim_installed?

          system File.join(File.dirname(__FILE__), "..", "bash", "install_vim")
        else
          dir = Dir.mktmpdir
          begin
          ensure
            FileUtils.remove_entry_secure dir
          end
        end
      end

      # Install the supplementary {dictionaries}[https://github.com/brymck/konjac_yml]
      def install_dictionaries
        if dictionaries_installed?
          update_dictionaries
        else
          Dir.chdir(konjac_home) do
            g = Git.clone(YML_GIT, ".dictionaries", :name => ".dictionaries",
              :path => konjac_home)
            g.chdir do
              FileUtils.cp_r Dir.glob("*.yml"), konjac_home
            end
          end
        end
      end

      # Update the supplementary {Vim plugin}[https://github.com/brymck/konjac_vim]
      def update_vim
        if has_pathogen? && vim_installed?
          system File.join(File.dirname(__FILE__), "..", "bash", "update_vim")
        else
          install_vim
        end
      end

      # Update the supplementary {dictionaries}[https://github.com/brymck/konjac_yml]
      def update_dictionaries
        if dictionaries_installed?
          g = Git.open(File.join(konjac_home, ".dictionaries"))
          g.pull
          g.chdir do
            FileUtils.cp_r Dir.glob("*.yml"), konjac_home
          end
        else
          install_dictionaries
        end
      end

      # Update everything
      def update
        update_dictionaries
        update_vim
      end

      private

      # Determines the location of Vim's home directory. This is currently
      # pretty naïve, but I'll build in functionality later to allow for
      # customized home directories.
      def vim_home
        @vim_home ||= File.join(File.expand_path(Dir.home),
                        RUBY_PLATFORM =~ /mswin32/ ? "vimfiles" : ".vim")
      end

      # The path for Konjac's configuration and dictionary files
      def konjac_home
        @konjac_home ||= File.join(File.expand_path(Dir.home), ".konjac")
      end

      # Whether the user has {Pathogen}[http://www.vim.org/scripts/script.php?script_id=2332]
      def has_pathogen?
        File.exists? File.join(vim_home, "autoload", "pathogen.vim")
      end

      # Whether the user has the Vim plugin installed
      def vim_installed?
        if has_pathogen?
          File.exist? File.join(vim_home, "bundle", "konjac_vim")
        else
          File.exist? File.join(vim_home, "plugin", "konjac.vim")
        end
      end

      # Whether the user has the supplementary dictionaries installed
      def dictionaries_installed?
        File.exist? File.join(konjac_home, ".dictionaries", ".git")
      end
    end
  end
end
