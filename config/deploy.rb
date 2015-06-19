# config valid only for current version of Capistrano
lock '3.3.5'

set :application, 'PIMS'
set :repo_url, "https://pijiti@github.com/pijiti/PIMS.git"

set :user, "ubuntu"

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call
set :branch, ENV['BRANCH'] || 'bug_fixes'
set :rails_env, "production"
# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/apps/PIMS'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
 set :keep_releases, 3

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      execute 'cd /apps/PIMS/current; RAILS_ENV=production bundle exec rake db:migrate; RAILS_ENV=production bundle exec rake assets:precompile'
      execute '/etc/init.d/unicorn_pims stop'
      execute 'sleep 5'
      execute '/etc/init.d/unicorn_pims start'
    end
  end



end
