source "https://rubygems.org"
ruby "2.4.0"

gem "rails", "~> 5.1.0"

gem "active_model_serializers", "~> 0.10.0"
gem "bcrypt", "~> 3.1.7"
gem "curb", "0.9.1"
gem "delayed_job", "4.1.3"
gem "delayed_job_active_record", "4.1.2"
gem "delayed_cron_job"
gem "knock", "~> 2.1.1"
gem "pg"
gem "puma", "~> 3.0"
gem "rack-cors"

group :development, :test do
  gem "bullet"
  gem "factory_girl_rails"
  gem "faker", "~> 1.7.0"
  gem "pry-byebug"
  gem "reek", require: false
  gem "rspec-rails"
  gem "rspec-rails-swagger"
  gem "rubocop", require: false
  gem "webmock"
end

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem "listen", "~> 3.0.5"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

group :test do
  gem "codecov", require: false
  gem "database_cleaner"
  gem "shoulda-matchers", "~> 3.1"
  gem "simplecov", require: false
end

group :production do
  gem "redis"
  gem "rollbar"
end
