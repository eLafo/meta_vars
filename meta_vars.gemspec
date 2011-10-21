# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "meta_vars/version"

Gem::Specification.new do |s|
  s.name        = "meta_vars"
  s.version     = MetaVars::VERSION
  s.authors     = ["eLafo"]
  s.email       = ["javierlafora@gmail.com"]
  s.homepage    = "https://github.com/eLafo/meta_vars"
  s.summary     = %q{Creates variables for an object, which their value depends on some context}
  s.description = %q{Creates variables for an object, which their value depends on some context. These vars will be accessible by methods and will be contained in an instance var -a container}

  s.rubyforge_project = "meta_vars"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
