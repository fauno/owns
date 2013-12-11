module Owns
  class Config
    attr_accessor :config

    def initialize(config_path='config.yml')
      require 'yaml'
      begin
        config_path = File.realpath(config_path)
      rescue
        raise IOError, "File #{config_path} not found"
      end

      @config = YAML.load_file(config_path)

    end
  end
end