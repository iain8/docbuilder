require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec)

RuboCop::RakeTask.new(:rubocop) do |task|
  task.patterns = ['lib/**/*.rb', 'spec/**/*.rb']
end

desc 'Run all tests'
task :test do
  Rake::Task['spec'].invoke
end

desc 'Lint code'
task :lint do
  Rake::Task['rubocop'].invoke
end

desc 'Start dev server'
task :start do
  sh 'rerun ruby lib/docbuilder.rb serve'  
end

desc 'Generate PDF document'
task :generate do
  ruby 'lib/docbuilder.rb build'
end

