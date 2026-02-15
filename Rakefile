require 'rake/testtask'
require 'rspec/core/rake_task'

# Default version is 'original'
VERSION = ENV.fetch('VERSION', 'original')

namespace :test do
  Rake::TestTask.new(:minitest) do |t|
    t.libs << 'test'
    t.libs << 'lib'
    t.test_files = FileList['test/**/*_test.rb']
    t.verbose = true
  end

  RSpec::Core::RakeTask.new(:rspec) do |t|
    t.pattern = 'spec/**/*_spec.rb'
  end
end

desc "Run all tests for VERSION=#{VERSION}"
task :test => ['test:minitest', 'test:rspec']

task :default => :test

desc 'List available versions'
task :versions do
  versions = Dir.glob('lib/*_*.rb')
    .map { |f| File.basename(f, '.rb').split('_').last }
    .uniq
    .sort
  puts "Available versions:"
  versions.each { |v| puts "  - #{v}" }
  puts "\nUsage: VERSION=<version> rake test"
end
