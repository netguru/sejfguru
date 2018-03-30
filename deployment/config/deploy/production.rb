server ENV['PRODUCTION_SERVER'], user: ENV['PRODUCTION_USER'], roles: %w[app db web]
set :branch, 'production-correction'
set :dockerfile, -> { 'docker/Dockerfile.production' }
set :project, -> { "#{fetch(:application)}_#{fetch(:stage)}" }

namespace :deploy do
  def compose(cmd)
    "-p #{fetch(:project)} -f docker-compose-#{fetch(:stage)}.yml #{cmd}"
  end

  after :updated, 'compose:deploy' do
    on roles(:app) do
      within release_path do
        execute :"docker-compose", compose("build")
        # run migration
        execute :"docker-compose", compose("run --rm web bin/sejfguru migrate")

        execute :"docker-compose", compose("up -d")
      end
    end
  end
end
