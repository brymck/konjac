# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "konjac/version"

Gem::Specification.new do |s|
  s.name        = "konjac"
  s.version     = Konjac::VERSION
  s.authors     = ["Bryan McKelvey"]
  s.email       = ["bryan.mckelvey@gmail.com"]
  s.homepage    = "http://brymck.herokuapp.com/"
  s.summary     = %q{A Ruby command-line utility for translating files using a YAML wordlist}
  s.description = %q{A Ruby command-line utility for translating files using a YAML wordlist}

  s.rubyforge_project = "konjac"

  s.extra_rdoc_files = ["README.rdoc"]
  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables      = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths    = ["lib"]

  s.add_runtime_dependency "amatch"
  s.add_runtime_dependency "i18n"
  s.add_runtime_dependency "nokogiri"
  s.add_runtime_dependency "sdoc"
  s.add_runtime_dependency "term-ansicolor"
  s.add_runtime_dependency "trollop"
  s.add_development_dependency "autotest"
  s.add_development_dependency "autotest-fsevent"
  s.add_development_dependency "autotest-growl"
  s.add_development_dependency "bundler"
  s.add_development_dependency "rspec"
end
