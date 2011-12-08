set :application, 'nerve_synapse'
set :repository,  'git@seeweer.com:nerve_synapse.git'
set :stages, %w(development)
set :scm_verbose, true
set :scm, :git

require 'capistrano/ext/multistage'
require 'bundler/capistrano'

namespace :deploy do
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
end
