# frozen_string_literal: true

require "bundler/gem_tasks"
require "standard/rake"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/test_*.rb"]
end

desc "Run performance benchmarks, failing if any operation's runtime is scaling worse than expected"
task :benchmark do
  FileList["test/benchmark/*_benchmark.rb"].sort.each { |f| load f }
end

task default: %i[test standard]
