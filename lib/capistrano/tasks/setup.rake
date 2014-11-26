desc 'Install the server and all its dependencies'
namespace :setup do
  desc ''
  task :update_pacman do
    on roles :all do
      execute :pacman, '-Syy' # update package repositories
    end
  end

  task :download_rvm_keys do
    on roles :all do
      execute :curl, '-sSL', 'https://rvm.io/mpapis.asc', '|', :gpg2, '--import', '-'
    end
  end

  task :install_unicorn do

    unicorn_config = <<-EOF
      [Unit]
      Description=Unicorn: Rack HTTP server for fast clients and Unix
      After=syslog.target network.target

      [Service]
      WorkingDirectory=/srv/bookstore/current/bookstore-rails
      ExecStart=#{fetch(:rvm1_auto_script_path)}/rvm-auto.sh #{fetch(:rvm1_ruby_version)} bundle exec unicorn_rails --conf unicorn.conf

      [Install]
      WantedBy=multi-user.target
    EOF

    on roles :all do
      # install unicorn as a system service
      upload! StringIO.new(unicorn_config), '/usr/lib/systemd/system/unicorn.service'
      execute :systemctl, :enable, :unicorn
      execute :systemctl, :start, :unicorn
    end
  end

  task :install_nginx do
    on roles :all do
      execute :pacman, '-S', '--noconfirm', :nginx
      upload! 'nginx.conf', '/etc/nginx/nginx.conf'
      execute :systemctl, :enable, :nginx
      execute :systemctl, :start, :nginx
    end
  end

  task :test do
    on roles :all do
      execute "#{fetch(:rvm1_auto_script_path)}/rvm-auto.sh #{fetch(:rvm1_ruby_version)}", :bundle, :exec, :rails, :server
    end
  end
end

task setup: ['setup:update_pacman', 'setup:download_rvm_keys', 'rvm1:install:rvm', 'rvm1:install:ruby', 'setup:install_unicorn', 'setup:install_nginx']