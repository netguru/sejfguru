server ENV['PRODUCTION_SERVER'], user: ENV['PRODUCTION_USER'], roles: %w[app db web]
set :branch, 'production'
set :dockerfile, -> { 'docker/Dockerfile.production' }

namespace :deploy do
  def compose(cmd)
    "-p #{fetch(:project)}-prerun -f docker-compose-#{fetch(:stage)}.yml #{cmd}"
  end

  after :updated, 'compose:deploy' do
    on roles(:app) do
      within release_path do
        execute :"docker-compose", compose("-f docker-compose-#{fetch(:stage)}.yml build")
        # run migration
        execute :"docker-compose", compose("run --rm web bin/sejfguru migrate")

        execute :"docker-compose", compose("-f docker-compose-#{fetch(:stage)}.yml up -d")
      end
    end
  end
end
