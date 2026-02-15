require 'rake/testtask'
require 'rspec/core/rake_task'

# Before tests - Minitest
namespace :test do
  namespace :before do
    Rake::TestTask.new(:minitest) do |t|
      t.libs << 'before/test'
      t.libs << 'before/lib'
      t.test_files = FileList['before/test/**/*_test.rb']
      t.verbose = true
    end

    RSpec::Core::RakeTask.new(:rspec) do |t|
      t.pattern = 'before/spec/**/*_spec.rb'
    end
  end

  desc 'Run all before tests (minitest and rspec)'
  task :before => ['before:minitest', 'before:rspec']

  # After tests - Minitest (will be available when after/ is created)
  namespace :after do
    Rake::TestTask.new(:minitest) do |t|
      t.libs << 'after/test'
      t.libs << 'after/lib'
      t.test_files = FileList['after/test/**/*_test.rb']
      t.verbose = true
    end

    RSpec::Core::RakeTask.new(:rspec) do |t|
      t.pattern = 'after/spec/**/*_spec.rb'
    end
  end

  desc 'Run all after tests (minitest and rspec)'
  task :after => ['after:minitest', 'after:rspec']
end

desc 'Run all tests (before and after)'
task :test => ['test:before']

task :default => :test
