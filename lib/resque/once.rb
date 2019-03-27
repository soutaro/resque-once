require "resque/once/version"

if defined?(Rails)
  class MyRailtie < Rails::Railtie
    rake_tasks do
      require "resque/once/tasks"
    end
  end
end
