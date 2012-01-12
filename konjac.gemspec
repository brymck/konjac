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

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "autotest"
  s.add_development_dependency "rspec"
  s.add_runtime_dependency "trollop"
end
