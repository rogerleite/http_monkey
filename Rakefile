require "bundler/gem_tasks"
require "rake/testtask"

ENV["RUBYOPT"] = "rubygems" if ENV["RUBYOPT"].nil?

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/http_monkey/**/*_test.rb']
end

Rake::TestTask.new("test:integration") do |t|
  t.libs << "test"
  t.pattern = "test/integration/*_test.rb"
end

desc "For Travis CI with love"
task :ci => [:test, :"test:integration"]

task :default => :ci
