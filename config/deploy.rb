
require "bundler/capistrano"

server "188.166.164.6", :web, :app 

server "smartimmo.cjo5yvp83xfv.eu-west-1.rds.amazonaws.com:5432", :db, primary: true

set :application, "smart-immo"
set :user, "deployer"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository, "git@github.com:laminovik/#{application}.git"
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases

namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: {no_release: true} do
      run "/etc/init.d/unicorn_#{application} #{command}"
    end
  end

  task :setup_config, roles: :app do
    sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
    sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
    run "mkdir -p #{shared_path}/config"
    #ligne ajoutée pour créer sous-dossier initializers
    run "mkdir -p #{shared_path}/config/initializers"
    put File.read("config/example_database.yml"), "#{shared_path}/config/database.yml"
    #ces 2 lignes ajoutées pour créer les autres fichiers de .gitignore
    put File.read("config/example_secrets.yml"), "#{shared_path}/config/secrets.yml"
    put File.read("config/initializers/example_devise.rb"), "#{shared_path}/config/initializers/devise.rb"
    puts "Now edit the config files in #{shared_path}."
  end
  after "deploy:setup", "deploy:setup_config"

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  after "deploy:finalize_update", "deploy:symlink_config"

  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end
  before "deploy", "deploy:check_revision"
end