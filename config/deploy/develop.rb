role :app, %w{localhost:2222}, user: 'root', password: 'vagrant' # don't hardcode in production!

set :default_env, { rvm_bin_path: '~/.rvm/bin' }
set :bundle_gemfile, './bookstore-rails/Gemfile'
set :rvm1_ruby_version, '2.1.4'