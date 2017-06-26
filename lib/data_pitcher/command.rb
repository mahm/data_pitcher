module DataPitcher
  class Command
    def initialize(spreadsheet_key, sql_path, dry_run: true, index: 1)
      @spreadsheet_key = spreadsheet_key
      @sql_path = sql_path
      @dry_run = dry_run
      @index = index
    end

    def execute
      @dry_run ? dry_run : run
    end

    def dry_run
      puts dry_run_log
      false
    end

    def run
      unless spreadsheet.valid?
        puts "[ERROR] ##{@index} command skipped: DataPitcher can not access to spreadsheet (#{@spreadsheet_key})"
        return false
      end
      unless executor.valid?
        puts "[ERROR] ##{@index} command skipped: SQL is invalid (#{@sql_path})"
        return false
      end
      spreadsheet.replace_worksheet_with_query(sql_query)
    end

    def spreadsheet
      @spreadsheet ||= DataPitcher::Spreadsheet.new(@spreadsheet_key)
    end

    def executor
      @executor ||= DataPitcher::Executor.new(sql_query)
    end

    def sql_query
      @sql_query ||= File.read(@sql_path)
    end

    def dry_run_log
      <<-EOS
##{@index} command
  spreadsheet_key: #{@spreadsheet_key}
    valid?: #{spreadsheet.valid?}
  sql_path: #{@sql_path}
    valid?: #{executor.valid?}
      EOS
    end
  end
end
