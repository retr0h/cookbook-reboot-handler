require "foodcritic"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:unit) do |t|
  t.rspec_opts = [].tap do |a|
    a.push('--color')
    a.push('--format progress')
  end.join(' ')
end

FoodCritic::Rake::LintTask.new

task :test => [:unit, :foodcritic]
task :default => [:test]
