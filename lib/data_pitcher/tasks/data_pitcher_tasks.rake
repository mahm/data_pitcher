namespace :data_pitcher do
  desc 'Export data to google spreadsheets with SQL'
  namespace :export do
    task run: :environment do
      export(dry_run: false)
    end
    task dry_run: :environment do
      export(dry_run: true)
    end
  end
end

def export(dry_run: true)
  puts "** Start export data / sending: #{!dry_run}"
  DataPitcher::Batch.new.execute(dry_run: dry_run)
  puts "** Completed export data / sending: #{!dry_run}"
end
