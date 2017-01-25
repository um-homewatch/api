source "https://rubygems.org"
ruby "2.3.1"

gem "rails", "~> 5.0.0", ">= 5.0.0.1"

gem "active_model_serializers", "~> 0.10.0"
gem "devise_token_auth"
gem "foreman"
gem "pg"
gem "pry-rails"
gem "pry-remote"
gem "puma", "~> 3.0"

group :development, :test do
  gem "factory_girl_rails"
  gem "faker"
  gem "pry-byebug"
  gem "rspec-rails"
  gem "rubocop", require: false
end

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem "listen", "~> 3.0.5"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

group :test do
  gem "database_cleaner"
  gem "simplecov", require: false
end
