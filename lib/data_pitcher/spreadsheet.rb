require 'google_drive'

module DataPitcher
  class Spreadsheet
    BATCH_SIZE = 1000

    def initialize(spreadsheet_key)
      @spreadsheet_key = spreadsheet_key
    end

    def spreadsheet
      @spreadsheet ||= session.spreadsheet_by_key(@spreadsheet_key)
    end

    def worksheet
      # NOTE: DataPitcher will access first sheet only
      @worksheet ||= spreadsheet.worksheets.first
    end

    def clear_sheet
      worksheet.reload
      worksheet.delete_rows(1, worksheet.num_rows)
      worksheet.save
    end

    def fill_sheet(sql_query)
      result = DataPitcher::Executor.new(sql_query).execute
      worksheet.reload
      # fill header
      worksheet.insert_rows(1, [result.header])
      # fill rows
      result.rows.each_slice(BATCH_SIZE).with_index do |array, batch_index|
        worksheet.insert_rows(2 + batch_index * BATCH_SIZE, array)
        worksheet.save
      end
    end

    def replace_worksheet_with_query(sql_query)
      clear_sheet
      fill_sheet(sql_query)
    end

    def valid?
      worksheet
      true
    rescue => e
      false
    end

    def session
      @session ||= ::GoogleDrive::Session.from_service_account_key(DataPitcher.configuration.google_service_account_json_path)
    end
  end
end
