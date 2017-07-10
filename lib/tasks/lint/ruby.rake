if %w[development test].include? Rails.env
  namespace :lint do
    namespace :ruby do
      require "reek/rake/task"
      Reek::Rake::Task.new { |task| task.verbose = true }

      require "rubocop/rake_task"
      RuboCop::RakeTask.new
    end
  end
end
