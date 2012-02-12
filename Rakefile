require "bundler/gem_tasks"
require "rdoc/task"
require "rspec/core/rake_task"
require "sdoc"

namespace :spec do
  desc "Run specs for Excel"
  RSpec::Core::RakeTask.new(:excel) do |t|
    t.rspec_opts = ["--tag", "excel"]
  end

  desc "Run specs for PowerPoint"
  RSpec::Core::RakeTask.new(:power_point) do |t|
    t.rspec_opts = ["--tag", "power_point"]
  end

  desc "Run specs for Word"
  RSpec::Core::RakeTask.new(:word) do |t|
    t.rspec_opts = ["--tag", "word"]
  end

  desc "Run all specs"
  task :all => ["spec", :excel, :power_point, :word]
end

desc "Run specs"
RSpec::Core::RakeTask.new

# Quick hack until SDoc gets fixed
class RDoc::Generator::SDoc; alias :basedir :base_dir; end

RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = "doc/rdoc"
  rdoc.title = "Konjac Documentation"

  rdoc.options << "-f" << "sdoc"         # format with SDoc
  rdoc.options << "-T" << "rails"        # use the Rails template
  rdoc.options << "-c" << "utf-8"
  rdoc.options << "-g"                   # link to GitHub
  rdoc.options << "-m" << "README.rdoc"  # use README.rdoc as main file
  rdoc.options << "-v"                   # verbose

  rdoc.rdoc_files.include "README.rdoc"
  rdoc.rdoc_files.include "ext/**/*.{c, h, rb}"
  rdoc.rdoc_files.include "lib/**/*.rb"
end
