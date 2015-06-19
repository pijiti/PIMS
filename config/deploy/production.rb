# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.
role :app, %w{ubuntu@52.25.33.102}
role :web, %w{ubuntu@52.25.33.102}
role :db,  %w{ubuntu@52.25.33.102}



# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.

set :rails_env, :production
server '52.25.33.102', user: 'ubuntu', roles: %w{web app}, my_property: :my_value


# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult[net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start).
#
# Global options
# --------------
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
#
# And/or per server (overrides global)
# ------------------------------------
 server '52.25.33.102',
  user: 'ubuntu',
  roles: %w{web app},
     ssh_options: {
  user: 'ubuntu', # overrides user setting above
    keys: %w(~/.ssh/id_rsa),
     forward_agent: true,
     auth_methods: %w(publickey)
     # password: 'please use keys'
   }



namespace :assets do
  desc 'compile assets locally and upload before finalize_update'

  task :deploy do
    on roles(:web) do
      execute 'cd /apps/PIMS/current; RAILS_ENV=production bundle exec rake db:migrate'
      execute '/etc/init.d/unicorn_attendant stop'
      execute 'sleep 5'
      execute '/etc/init.d/unicorn_attendant start'
    end
  end
end

