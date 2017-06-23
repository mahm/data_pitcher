namespace :data_pitcher do
  desc 'Export data to google spreadsheets with SQL'
  task execute: :environment do
    DataPitcher::Batch.new.execute
  end
end
