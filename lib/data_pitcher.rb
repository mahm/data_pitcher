require 'data_pitcher/version'
require 'data_pitcher/configuration'
require 'data_pitcher/executor'
require 'data_pitcher/result'
require 'data_pitcher/spreadsheet'
require 'data_pitcher/batch'
require 'data_pitcher/command'
require 'data_pitcher/core_ext/time'

module DataPitcher
  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end

require 'data_pitcher/railtie' if defined?(Rails::Railtie)
