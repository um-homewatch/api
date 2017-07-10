desc "Run all linters"
task lint: ["lint:ruby:rubocop", "lint:ruby:reek"]
