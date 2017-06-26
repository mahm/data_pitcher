require 'google_drive'

module DataPitcher
  class Spreadsheet
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
      (1..worksheet.num_rows).each do |row|
        (1..worksheet.num_cols).each do |col|
          worksheet[row, col] = ''
        end
      end
      worksheet.save
    end

    def fill_sheet(sql_query)
      result = DataPitcher::Executor.new(sql_query).execute
      worksheet.reload
      # fill header
      result.header.each.with_index(1) do |val, col_index|
        worksheet[1, col_index] = val
      end
      # fill rows
      result.rows.each.with_index(2) do |row, row_index|
        row.each.with_index(1) do |val, col_index|
          worksheet[row_index, col_index] = val
        end
      end
      worksheet.save
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
