source 'https://rubygems.org'

gem 'jruby-openssl', platforms: :jruby
gem 'rake'

group :development do
  gem 'awesome_print', require: 'ap'
  gem 'guard-rspec'
  gem 'hirb-unicode'
  gem 'pry'
  gem 'redcarpet'
  gem 'wirb'
  gem 'wirble'
  gem 'yard'
  gem 'rubocop'
end

group :test do
  gem 'coveralls', require: false
  gem 'mime-types', '< 2.0.0'
  gem 'netrc', '~> 0.7'
  gem 'rb-fsevent', '~> 0.9'
  gem 'rspec', '~> 3.0'
  gem 'simplecov', require: false
  gem 'vcr', '~> 2.9.2'
  gem 'multi_json'
  gem 'webmock', '>= 1.9'
end

platforms :rbx do
  gem 'psych'
  gem 'rubysl', '~> 2.0'
end

gemspec
