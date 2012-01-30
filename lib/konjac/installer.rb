# coding: utf-8
module Konjac
  # A class to help with installing supplementary tools for Konjac
  module Installer
    VIM_GIT = "git://github.com/brymck/konjac_vim.git"
    YML_GIT = "git://github.com/brymck/konjac_yml.git"

    class << self
      # Parses the provided command and script to install or update plugins and
      # dictionary files
      def run(command, script)
        case script.to_sym
        when :dictionaries, :dict, :dictionary
          script = "dictionaries"
        when :vim
          script = "vim"
        else
          puts I18n.t(:script_not_found, :scope => :scripts) % script
          return 
        end

        case command.to_sym
        when :install, :update
          # Build a command
          __send__ [command, script].join("_")
        else
          puts I18n.t(:command_not_found, :scope => :scripts) % command
        end
      end
      
      # Install the supplementary {Vim plugin}[https://github.com/brymck/konjac_vim]
      def install_vim
        return update_vim if has_pathogen? && vim_installed?

        puts I18n.t(:installing, :scope => :scripts) % I18n.t(:vim_script, :scope => :scripts)
        if has_pathogen?
          Dir.chdir(vim_home) do
            system "git submodule add #{VIM_GIT} bundle/konjac_vim"
            system "git submodule init"
            system "git submodule update"
          end
        else
          dir = Dir.mktmpdir
          begin
          ensure
            FileUtils.remove_entry_secure dir
          end
        end
        puts I18n.t(:done, :scope => :scripts).capitalize
      end

      # Install the supplementary {dictionaries}[https://github.com/brymck/konjac_yml]
      def install_dictionaries
        if dictionaries_installed?
          update_dictionaries
        else
          print I18n.t(:installing, :scope => :scripts) % I18n.t(:dictionaries, :scope => :scripts)
          Dir.chdir(konjac_home) do
            g = Git.clone(YML_GIT, ".dictionaries", :name => ".dictionaries",
              :path => konjac_home)
            g.chdir do
              FileUtils.cp_r Dir.glob("*.yml"), konjac_home
            end
          end
          puts I18n.t(:done, :scope => :scripts)
        end
      end

      # Update the supplementary {Vim plugin}[https://github.com/brymck/konjac_vim]
      def update_vim
        if has_pathogen? && vim_installed?
          puts I18n.t(:updating, :scope => :scripts) % I18n.t(:vim_script, :scope => :scripts)
          Dir.chdir(File.join(vim_home, "bundle", "konjac_vim")) do
            system "git pull origin master"
          end
          system File.join(File.dirname(__FILE__), "..", "bash", "update_vim")
          puts I18n.t(:done, :scope => :scripts)
        else
          install_vim
        end
      end

      # Update the supplementary {dictionaries}[https://github.com/brymck/konjac_yml]
      def update_dictionaries
        if dictionaries_installed?
          print I18n.t(:installing, :scope => :scripts) % I18n.t(:dictionaries, :scope => :scripts)
          g = Git.open(File.join(konjac_home, ".dictionaries"))
          g.pull
          g.chdir do
            FileUtils.cp_r Dir.glob("*.yml"), konjac_home
          end
          puts I18n.t(:done, :scope => :scripts)
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
