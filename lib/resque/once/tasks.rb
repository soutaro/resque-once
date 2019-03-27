require 'resque/tasks'

namespace :resque do
  desc "Start a one-off Resque worker"
  task :once => [:preload, :setup] do
    require 'resque'

    begin
      worker = Resque::Worker.new
      worker.fork_per_job = false
    rescue Resque::NoQueueError
      abort "set QUEUE env var, e.g. $ QUEUE=critical,high rake resque:work"
    end

    worker.prepare
    worker.log "Starting once worker #{self}"
    worker.work(ENV['INTERVAL'] || 5) {|job|
      worker.log "Shutting down... #{self}"
      worker.shutdown
    }
  end
end
