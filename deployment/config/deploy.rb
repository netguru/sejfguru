lock '3.9.0'

set :application, "sejfguru"
set :repo_url, 'git@github.com:netguru/sejfguru.git'
set :deploy_to, "/home/deploy/apps/#{fetch(:application)}"
set :secrets_file, "/home/deploy/apps/#{fetch(:application)}/shared/exported_secrets.env"

namespace :deploy do
  after :updated, 'copy_files' do
    on roles(:app) do
      within release_path do
        execute :cp, "#{fetch(:secrets_file)}", release_path.join("secrets.env")
      end
    end
  end
end
