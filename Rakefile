require 'rake/testtask'

# Default version is 'original'
VERSION = ENV.fetch('VERSION', 'original')

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end

task :default => :test

desc 'List available versions'
task :versions do
  versions = Dir.glob('lib/*/').map { |d| File.basename(d) }.sort
  puts "Available versions:"
  versions.each { |v| puts "  - #{v}" }
  puts "\nUsage: VERSION=<version> rake test"
end
