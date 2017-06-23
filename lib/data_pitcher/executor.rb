module DataPitcher
  class Executor
    def initialize(query)
      @query = query
    end

    def execute
      result(select(@query))
    end

    private

    def connection
      ActiveRecord::Base.connection
    end

    def with_sandbox
      result = nil
      connection.transaction do
        result = yield
        raise ActiveRecord::Rollback
      end
      result
    end

    def select(query)
      with_sandbox do
        connection.exec_query(query)
      end
    end

    def result(ar)
      DataPitcher::Result.new(ar.columns, ar.rows)
    end
  end
end
