# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'



require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "cordon"
  gem.homepage = "http://github.com/geeksam/cordon"
  gem.license = "WTFPL"
  gem.summary = %Q{Cordon Sanitaire: hygienic handling of infectious methods}
  gem.description = %Q{A bit of an experiment, really}
  gem.email = "geeksam@gmail.com"
  gem.authors = ["Sam Livingston-Gray"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new



require 'rake/testtask'
require 'rspec/core/rake_task'
namespace :test do
  task :all => ['test:unit', 'test:rspec']

  Rake::TestTask.new(:unit) do |t|
    t.libs << 'lib' << 'test'
    t.pattern = 'test/unit/*_test.rb'
    t.verbose = true
  end

  desc 'Run all integration tests'
  task :integration => ['test:rspec']

  RSpec::Core::RakeTask.new(:rspec) do |t|
    t.pattern = 'test/integration/rspec_spec.rb'
    t.verbose = true
  end
end
task :default => ['test:all']


require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "cordon #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
