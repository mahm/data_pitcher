module DataPitcher
  class Configuration
    attr_accessor :google_service_account_json_path
    attr_accessor :data_pitcher_yaml_path

    def initialize
      @google_service_account_json_path = Rails.root.join('config', 'service_account.json')
      @data_pitcher_yaml_path = Rails.root.join('config', 'data_pitcher.yml')
    end
  end
end
