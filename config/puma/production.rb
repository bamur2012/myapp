# Place in /config/puma/production.rb

rrails_env = 'production'
environment rails_env

#environment ENV.fetch('RAILS_ENV', 'production')

app_dir = '/home/bamur/myapp/current' # Update me with your root rails app path

bind "unix:///home/bamur/myapp/current/shared/tmp/sockets/myapp-puma.sock"
pidfile "#{app_dir}/shared/tmp/pids/puma.pid"
state_path "#{app_dir}/shared/tmp/pids/puma.state"
directory "#{app_dir}/"

stdout_redirect "#{app_dir}/log/puma.stdout.log", "#{app_dir}/log/puma.stderr.log", true

workers 2
threads 1, 2

activate_control_app "unix://#{app_dir}/pumactl.sock"

prune_bundler
