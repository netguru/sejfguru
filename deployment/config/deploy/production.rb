server ENV['PRODUCTION_SERVER'], user: ENV['PRODUCTION_USER'], roles: %w[app db web]
set :branch, 'production-setup'
set :dockerfile, -> { 'docker/Dockerfile.production' }
set :capose_commands, -> {
  [
    'build',
    'run --rm web bin/sejfguru migrate',
    'up -d'
  ]
}
