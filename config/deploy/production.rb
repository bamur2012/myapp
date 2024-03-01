set :stage, :production

role :app, %w[bamur@192.168.31.31]
role :web, %w[bamur@192.168.31.31]
role :db,  %w[bamur@192.168.31.31]

set :rvm_ruby_version, "3.0.1@#{fetch(:application)}"
set :rails_env, :production
