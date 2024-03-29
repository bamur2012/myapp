# config valid only for current version of Capistrano
lock '3.18.0'

set :application, 'myapp'
set :repo_url, 'git@github.com:bamur2012/myapp.git'
set :deploy_to, "/home/bamur/#{fetch(:application)}"
set :user, 'bamur'
set :rvm_ruby_version, '3.0.1'
set :linked_dirs, %w[log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads]
set :whenever_identifier, -> { "#{fetch(:application)}_#{fetch(:stage)}" }

set :puma_threads, [4, 16]
set :puma_workers, 2

set :pty,             false
set :use_sudo,        false
set :stage,           :production
set :deploy_via,      :remote_cache

# Don't change these unless you know what you're doing
set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w[~/.ssh/id_rsa.pub] }

set :puma_bind,       'unix:///home/bamur/myapp/shared/tmp/sockets/myapp-puma.sock'
set :puma_state,      '/home/bamur/myapp/shared/tmp/pids/puma.state'
set :puma_pid,        '/home/bamur/myapp/shared/tmp/pids/puma.pid'

set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true # Change to false when not using ActiveRecord
set :branch, "main"
namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  desc 'Make sure local git is in sync with remote.'
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/main`
        puts 'WARNING: HEAD is not the same as origin/main'
        puts 'Run `git push` to sync changes.'
        exit
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  before :starting,     :check_revision
  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  after  :finishing,    :restart
end
