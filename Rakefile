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

  gem.files.exclude *%w[ .document .rvmrc Gemfile Gemfile.lock]
end
Jeweler::RubygemsDotOrgTasks.new



require 'rake/testtask'
require 'rspec/core/rake_task'
namespace :test do
  desc 'Run all tests'
  task :all => ['test:integration', 'test:framework_integration']

  desc 'Run integration tests'
  Rake::TestTask.new(:integration) do |t|
    t.pattern = 'test/integration/*_test.rb'
    t.verbose = true
  end

  desc 'Run all framework integration tests'
  task :framework_integration => ['test:framework:rspec', 'test:framework:minitest_spec']

  namespace :framework do
    RSpec::Core::RakeTask.new(:rspec) do |t|
      t.pattern = 'test/framework_integration/rspec_spec.rb'
      t.verbose = true
    end

    Rake::TestTask.new(:minitest_spec) do |t|
      t.pattern = 'test/framework_integration/minitest_spec_spec.rb'
      t.verbose = true
    end
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


desc 'Quick and dirty SLOC counts'
task :stats do
  sloc_count = lambda do |glob_expression|
    glob_expression = File.join(File.dirname(__FILE__), glob_expression)
    lines_in_file = lambda { |filename| File.open(filename, 'r').readlines.reject { |line| line =~ /^\s*(#|$)/ }.length }
    n = Dir.glob(glob_expression).inject(0) { |n, f| n + lines_in_file[f] }
    n.to_f
  end
  lib  = sloc_count['lib/**/*.rb']
  test = sloc_count['test/**/*_{test,spec}.rb']
  puts <<-EOF
    Cordon code stats
    Lib LOC:  #{ '%3d' % lib }
    Test LOC: #{ '%3d' % test }
    Lib/test: #{ '%.1f' % (lib/test) }
EOF
end
