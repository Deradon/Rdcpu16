# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "dcpu16/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "Rdcpu16"
  s.version     = DCPU16::VERSION
  s.authors     = ["Patrick Helm"]
  s.email       = ["deradon87@gmail.com"]
  s.homepage    = "https://github.com/Deradon/Rdcpu16"#"https://github.com/Deradon/Ruby-Rescuetime"
  s.summary     = "Ruby port of DCPU16"
  s.description = "This is a simple Ruby port of the fictive 16-bit-cpu DCPU16."

  s.executables   = ["dcpu16"]
  s.files         = Dir["{bin,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files    = Dir["{spec}/**/*"]
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec", "~> 2.6"
end

