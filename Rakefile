require_relative "config/application"

Rails.application.load_tasks

if %w[development test].include? Rails.env
  Rake::Task[:default].prerequisites.clear

  if defined?(RSpec)
    desc "Run factory specs."
    task :factory_specs do
      FactoryGirl.lint(traits: true)
    end
  end

  if defined? RSpec
    task(:spec).clear
    desc "Run all specs/features in spec directory"
    RSpec::Core::RakeTask.new(spec: "db:test:prepare") do |t|
      t.pattern = "./spec/**/*{_spec.rb,.feature}"
    end
  end

  task spec: :factory_specs

  task :spec_and_lint do
    Rake::Task["spec"].invoke
    Rake::Task["lint"].invoke
  end

  task default: :spec_and_lint
end
