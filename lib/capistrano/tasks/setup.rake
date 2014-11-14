desc "Install the server and all its dependencies"
task :setup do
  on roles :all do
    execute :gem, :install, :bundler
    execute :echo, 'export PATH=$PATH:/root/.gem/ruby/2.1.0/bin', :>>, '.bashrc'
  end
end