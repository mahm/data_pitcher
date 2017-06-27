require 'erb'

module DataPitcher
  class Batch
    def initialize(yaml_path = DataPitcher.configuration.data_pitcher_yaml_path)
      @yaml_path = yaml_path
    end

    def commands
      # TODO: 例外処理
      YAML.load(ERB.new(File.read(@yaml_path)).result)['data_pitcher']
    end

    def execute(dry_run: true)
      commands.each.with_index(1) do |command, index|
        begin
          elapsed_time, result = Time.elapsed_time do
            DataPitcher::Command.new(command['spreadsheet_key'], command['sql_path'], dry_run: dry_run, index: index).execute
          end
          if result
            puts "##{index} command: sending completed. #{elapsed_time}s"
          end
        rescue => e
          puts "[ERROR] ##{index} command skipped: #{e.class} #{e.message}"
        end
      end
    end
  end
end
