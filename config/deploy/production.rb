#keys: %w(/home/user_name/.ssh/id_rsa)
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
#
# The server-based syntax can be used to override options:
# ------------------------------------
server "192.168.31.37",
user: "bamur",
roles: %w{web db app}


   set :stage, :production

#role :app, %w[bamur@192.168.31.37]
#role :web, %w[bamur@192.168.31.37]
#role :db,  %w[bamur@192.168.31.37]

set :rvm_ruby_version, "3.0.1@#{fetch(:application)}"
set :rails_env, :production

#   ssh_options: {
#     user: "user_name", # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: "please use keys"
#   }
