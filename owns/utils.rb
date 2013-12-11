require 'open3'
require 'net/https'

module Owns
  module Utils
    
    def self.run_process(line, message='')
      puts message if message
      Open3::popen3(line) do |stdin, stdout, stderr|
        puts 'Output:'
        puts stdout.read.strip

        puts 'Errors:'
        puts stderr.read.strip
      end
    end

    def self.get_bin(app)
      begin
        return `command -v #{app}`.strip
      rescue Errno::ENOENT
        app = `which #{app}`.strip
        if app.empty? then
          return false
        else
          return app
        end
      end
    end

    def self.get_public_address
      Net::HTTP.get(URI('https://icanhazip.com'))
    end
  end
end