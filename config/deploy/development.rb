#$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
#require "rvm/capistrano"

set :user, 'seeweer'
set :branch, 'master'
set :rails_env, :development
set :use_sudo, false
set :deploy_to, "/home/seeweer/projects/#{application}"
#set :rvm_ruby_string, '1.8.7'
#set :rvm_type, :user

role :web, '178.63.75.143'
role :app, '178.63.75.143'
role :db,  '178.63.75.143', :primary => true

desc 'Link in the development database.yml'
task :after_update_code do
  files = %w(database.yml application.yml)
  files.each {|file| run "ln -nfs #{shared_path}/etc/#{file} #{release_path}/config/#{file}" }
end

namespace :deploy do
  desc "precompile the assets"
  task :precompile_assets, :roles => :web, :except => { :no_release => true } do
    run "cd #{current_path}; rm -rf public/assets/*"
    run "cd #{current_path}; RAILS_ENV=production bundle exec rake assets:precompile"
  end
end

before "deploy:restart", "deploy:precompile_assets"
