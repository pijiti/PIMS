namespace :db_setup do
    desc 'Setup database'
    task :db_recreate do
      on roles(:db) do
        within release_path do
          with rails_env: fetch(:rails_env) do
            execute :rake, 'db:setup' # This recreates the database tables
          end
        end
      end
    end

    desc 'Database drop'
    task :db_drop do
      on roles(:db) do
        within release_path do
          with rails_env: fetch(:rails_env) do
            execute :rake, 'db:drop' # This drops the database tables
          end
        end
      end
    end

    desc 'Database seeding'
    task :db_seed do
      on roles(:db) do
        within release_path do
          with rails_env: fetch(:rails_env) do
            execute :rake, 'db:seed' # This seeds the database tables
          end
        end
      end
    end

end