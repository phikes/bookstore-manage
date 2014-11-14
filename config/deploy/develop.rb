role :app, %w{localhost:2222}, user: 'root', password: 'vagrant' # don't hardcode in production!

set :ssh_options, {
                    forward_agent: true, 
                    keys: ['~/.vagrant.d/insecure_private_key'],
                  }

set :branch, :develop
set :bundle_path, "#{release_path}/bookstore-rails/"
set :default_env, { rvm_bin_path: '~/.rvm/bin' }