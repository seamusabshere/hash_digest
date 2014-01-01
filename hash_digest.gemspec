# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "hash_digest/version"

Gem::Specification.new do |s|
  s.name        = "hash_digest"
  s.version     = HashDigest::VERSION
  s.authors     = ["Seamus Abshere"]
  s.email       = ["seamus@abshere.net"]
  s.homepage    = "https://github.com/seamusabshere/hash_digest"
  s.summary     = %q{Make consistent hashcodes from flat Hashes, regardless of key ordering}
  s.description = %q{Make consistent hashcodes from flat Hashes, regardless of key ordering. Useful for hashing rows in a table.}

  s.rubyforge_project = "hash_digest"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'murmurhash3'
  s.add_runtime_dependency 'escape_utils'

  s.add_development_dependency 'minitest'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'activesupport'
  s.add_development_dependency 'benchmark-ips'
end
