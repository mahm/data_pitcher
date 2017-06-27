class Time
  def self.elapsed_time
    start_time = Time.now
    result = yield
    end_time = Time.now
    [end_time - start_time, result]
  end
end
