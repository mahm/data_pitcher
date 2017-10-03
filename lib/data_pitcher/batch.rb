require 'erb'

module DataPitcher
  class Batch
    def initialize(yaml_path = DataPitcher.configuration.data_pitcher_yaml_path)
      @yaml_path = yaml_path
    end

    def command_hashes
      # TODO: 例外処理
      YAML.load(ERB.new(File.read(@yaml_path)).result)['data_pitcher']
    end

    def execute(dry_run: true)
      command_hashes.each.with_index(1) do |command_hash, index|
        begin
          result = false
          elapsed_time = Benchmark.realtime do
            result = DataPitcher::Command.new(
              spreadsheet_key: command_hash['spreadsheet_key'],
              worksheet_title: command_hash['worksheet_title'],
              sql_path: command_hash['sql_path'],
              dry_run: dry_run,
              index: index
            ).execute
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
