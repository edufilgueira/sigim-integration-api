source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.0"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.4"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Authorization
gem "oauth2", "2.0.9"
gem "rest-client", "2.1.0"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder", "2.11.5"
gem 'haml', "6.1.1"
gem "haml-rails", "2.1.0"
gem 'kaminari', "1.2.2"
gem 'jquery-rails', "4.5.1"
gem 'select2-rails', '4.0.13'
gem 'ransack', '~> 4.0'

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem "rack-cors"

# Access control
gem 'devise', '~> 4.8', '>= 4.8.1'

# Internacionalização
gem 'rails-i18n', '~> 7.0.0' # For 7.0.0

# The asset pipeline provides a framework to concatenate and minify or compress JavaScript and CSS assets. 
# It also adds the ability to write these assets in other languages and pre-processors such as CoffeeScript
# , Sass, and ERB. OBS USE( config\environments\development.rb discoment --> # config.sass.inline_source_maps = true)
gem "sassc-rails"

# Simple Form aims to be as flexible as possible while helping you with powerful components to create your forms
# gem 'simple_form'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 5.0'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  #gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
  gem 'rubocop', require: false
  gem 'rails_layout'
end

