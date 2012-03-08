# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{cordon}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Sam Livingston-Gray}]
  s.date = %q{2012-03-08}
  s.description = %q{A bit of an experiment, really}
  s.email = %q{geeksam@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.markdown"
  ]
  s.files = [
    "LICENSE.txt",
    "README.markdown",
    "Rakefile",
    "VERSION",
    "cordon.gemspec",
    "lib/cordon.rb",
    "lib/cordon/blacklist.rb",
    "lib/cordon/sanitaire.rb",
    "lib/cordon/violation.rb",
    "lib/cordon/whitelist.rb",
    "test/helper.rb",
    "test/integration/minitest_spec_spec.rb",
    "test/integration/rspec_spec.rb",
    "test/unit/backtrace_cleaning_unit_test.rb",
    "test/unit/cordon_basic_examples_unit_test.rb",
    "test/unit/cordon_default_behavior_unit_test.rb",
    "test/unit/cordon_edge_cases_unit_test.rb",
    "test/unit/unit_helper.rb"
  ]
  s.homepage = %q{http://github.com/geeksam/cordon}
  s.licenses = [%q{WTFPL}]
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{Cordon Sanitaire: hygienic handling of infectious methods}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.3"])
      s.add_development_dependency(%q<mocha>, ["~> 0.10.3"])
      s.add_development_dependency(%q<ruby-debug19>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<minitest>, [">= 0"])
    else
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.3"])
      s.add_dependency(%q<mocha>, ["~> 0.10.3"])
      s.add_dependency(%q<ruby-debug19>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<minitest>, [">= 0"])
    end
  else
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.3"])
    s.add_dependency(%q<mocha>, ["~> 0.10.3"])
    s.add_dependency(%q<ruby-debug19>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<minitest>, [">= 0"])
  end
end

