# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'bookstore'
set :repo_url, 'https://github.com/phikes/bookstore.git'
set :branch, :develop

set :deploy_to, '/srv/bookstore'

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app) do
      execute :systemctl, :restart, :unicorn
    end
  end

  before :restart, :migrate do
    on roles :all do
      within "#{current_path}/bookstore-rails" do
        execute :rake, :'db:migrate'
      end
    end
  end

  after :deploy, :restart

end
