# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

CryptoTeller::Application.load_tasks

namespace :sidekiq do
  task :monitor do
    require 'sidekiq/web'
    app = Sidekiq::Web
    app.set :environment, :production
    app.set :bind, '0.0.0.0'
    app.set :port, 9494
    app.run!
  end
end

namespace :teller do
  task :accept => :environment do
    transfer = Transfer.last
    transfer.update!(status: 'accepted')
    TransferWorker.perform_async(transfer.id)
  end
end
