module DataPitcher
  class Railtie < ::Rails::Railtie
    rake_tasks do
      load 'data_pitcher/tasks/data_pitcher_tasks.rake'
    end
  end
end
