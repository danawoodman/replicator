# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'replicator/version'
require 'date'

Gem::Specification.new do |s|
  s.required_ruby_version = '>= 1.9.2'
  s.add_dependency 'bundler', '~> 1.3'
  s.add_dependency 'rails', '4.0.0'
  s.authors = ['teleporter']
  s.date = Date.today.strftime('%Y-%m-%d')

  s.description = <<-HERE
Rails application generator used at Teleporter, based on thoughtbot/suspenders.
  HERE

  s.email = 'hire@teleporter.io'
  s.executables = `git ls-files -- bin/*`.split("\n").map { |file| File.basename(file) }
  s.extra_rdoc_files = %w[README.md LICENSE]
  s.files = `git ls-files`.split("\n")
  s.homepage = 'http://github.com/teleporter/replicator'
  s.license = 'MIT'
  s.name = 'rails-replicator'
  s.rdoc_options = ['--charset=UTF-8']
  s.require_paths = ['lib']
  s.summary = "Generate a Rails app using Teleporter's best practices."
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.version = Replicator::VERSION
end
