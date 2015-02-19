namespace :db_setup do
    desc 'Setup database'
    task :db_setup do
      on roles(:db) do
        within release_path do
          with rails_env: fetch(:rails_env) do
            execute :rake, 'db:setup' # This creates the database tables AND seeds
          end
        end
      end
    end
end