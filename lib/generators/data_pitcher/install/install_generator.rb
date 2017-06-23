require "rails"

module DataPitcher
  class InstallGenerator < ::Rails::Generators::Base
    def create_yaml_file
      create_file 'config/data_pitcher.yml' do
        <<-EOS
data_pitcher:
  - spreadsheet_key: <YOUR GOOGLE SPREADSHEET KEY>
    sql_path: <YOUR SQL FILE PATH>
        EOS
      end
    end

    def create_initializer_file
      initializer 'data_pitcher.rb' do
        <<-EOS
DataPitcher.configure do |config|
  config.google_service_account_json_path = Rails.root.join('config', 'service_account.json')
end
        EOS
      end
    end
  end
end
