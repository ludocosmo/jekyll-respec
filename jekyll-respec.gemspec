# frozen_string_literal: true
# coding: utf-8

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "jekyll-respec/version"

Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.rubygems_version = "2.2.2"
  s.required_ruby_version = ">= 2.1.0"

  s.name          = "jekyll-respec"
  s.version       = Jekyll::Respec::VERSION
  s.license       = "MIT"

  s.summary       = "Convert markdown to HTML respec."

  s.authors       = ["Ludovic Roux"]
  s.email         = "ludovic.roux@cosmosoftware.io"
  s.homepage      = "https://github.com/jekyll/jekyll-respec"

  # all_files       = `git ls-files -z`.split("\x0")
  s.files         = Dir["lib/**/*"]
  s.require_paths = ["lib"]

  s.rdoc_options = ["--charset=UTF-8"]
  s.extra_rdoc_files = %w(README.md LICENSE Gemfile jekyll-respec.gemspec)

  s.add_runtime_dependency("kramdown-respec", "~> 0.0")
end
