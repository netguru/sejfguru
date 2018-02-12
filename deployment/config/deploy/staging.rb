server ENV['STAGING_SERVER'], user: ENV['STAGING_USER'], roles: %w(app db web)

set :default_env, lambda {
  {
    'TIMESTAMP' => release_timestamp,
    'DOCKER_REPO' => ENV['DOCKER_REPO'],
    'VIRTUAL_HOST' => ENV['VIRTUAL_HOST']
  }
}
set :image, -> { "#{ENV['DOCKER_REPO']}:#{release_timestamp}" }
set :dockerfile, -> { 'docker/Dockerfile.staging' }
set :project, -> { "#{fetch(:application)}-#{fetch(:stage)}" }
set :branch, ENV['REVISION'] || 'master'

namespace :deploy do
  def compose(cmd)
    "-p #{fetch(:project)}-prerun -f docker-compose-#{fetch(:stage)}.yml #{cmd}"
  end

  after :updated, 'swarm:deploy' do
    on roles(:app) do
      within release_path do
        execute :docker, "build -t #{fetch(:image)} -f #{fetch(:dockerfile)} ."
        execute :docker, "push #{fetch(:image)}"

        # run migration
        execute :"docker-compose", compose("run --rm web bin/sejfguru migrate")

        execute :docker, "stack deploy -c docker-compose-#{fetch(:stage)}.yml --with-registry-auth #{fetch(:project)}"
      end
    end
  end
end
