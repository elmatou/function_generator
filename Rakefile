require "bundler/gem_tasks"
require 'rspec/core/rake_task'

desc "Run specs"
RSpec::Core::RakeTask.new :spec

task :default => :spec

# Irb console
desc 'Start an irb session and load the library.'
task :console do
    exec "irb -I lib -r function_generator"
end