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

    def execute
      commands.each do |command|
        DataPitcher::Spreadsheet.new(command['spreadsheet_key'], command['sql_path']).replace_worksheet_with_query
      end
    end
  end
end
