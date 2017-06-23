require 'google_drive'

module DataPitcher
  class Spreadsheet
    def initialize(spreadsheet_key, sql_path)
      @spreadsheet_key = spreadsheet_key
      @sql_path = sql_path
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

    def fill_sheet
      result = DataPitcher::Executor.new(read_query).execute
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

    def read_query
      # TODO: 例外処理
      File.open(@sql_path) do |file|
        file.read
      end
    end

    def replace_worksheet_with_query
      clear_sheet
      fill_sheet
    end

    def session
      @session ||= ::GoogleDrive::Session.from_service_account_key(DataPitcher.configuration.google_service_account_json_path)
    end
  end
end
