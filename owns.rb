PATHNAME = File.realpath(File.dirname(__FILE__))

require File.join(PATHNAME, 'owns/config.rb')
require File.join(PATHNAME, 'owns/template.rb')
require File.join(PATHNAME, 'owns/utils.rb')

module Owns
  def self.generate_nsd
    owns_data = Owns::Config.new.config

    puts 'Generating nsd.conf...'
    File.open(File.join(PATHNAME, "out/nsd.conf"), 'w+') do |nsd_conf|
      nsd_conf.write(Owns::Template::Nsd.render(owns_data))
    end
  end

  def self.create_zones
    require 'fileutils'

    owns_data  = Owns::Config.new.config
    zones_path = File.join(PATHNAME, 'out/zones')

    unless File.directory?(zones_path) then
      puts 'Creating zones directory...'
      FileUtils.mkdir_p('zones')
    end
    # Lingering zone files can trick nsd into believing we still serve
    # them...
    puts 'Removing old zones...'
    FileUtils.rm(Dir.glob(File.join(zones_path, '*.zone')))

    owns_data['public_address'] = Owns::Utils.get_public_address if owns_data['public_address'].nil?

    # Traverse all zones
    owns_data['zones'].each do |zone_data|
      # Merge with the general configuration, zone-specific info takes
      # precedence
      zone_data = owns_data.merge(zone_data)

      # If this zone is delegated to us, don't create a zone file so the
      # transfer is forced
      # next if not zone_data['authorities'].nil?

      # Generate a serial from the current time
      zone_data['serial'] = Time.new.to_i

      # Inform what we're doing
      puts "Generating #{zone_data['zone']} with serial #{zone_data['serial']}..."

      # Write the zonefile!
      File.open(File.join(zones_path, "#{zone_data['zone']}.zone"), 'w+') do |zone_file|
        zone_file.write(Owns::Template::Zone.render(zone_data))
      end

    end

    def self.set_config
      nsdc_bin = Owns::Utils.get_bin('nsd-control') or Owns::Utils.get_bin('nsdc')
      raise 'Cannot find nsd-control/nsdc' unless nsdc_bin
      conf = File.join(PATHNAME, '/out/nsd.conf')
      Owns::Utils.run_process("nsd-checkconf #{conf}", 'Checking configuration...')
      Owns::Utils.run_process("#{nsdc_bin} rebuild", 'Rebuilding zones...')
      Owns::Utils.run_process("#{nsdc_bin} stop", 'Stopping nsd...')
      Owns::Utils.run_process("#{nsdc_bin} start", 'Starting nsd...')
      Owns::Utils.run_process("#{nsdc_bin} notify", 'Notifying our presence...')
    end

  end
end

if __FILE__ == $0
  Owns.generate_nsd
  Owns.create_zones
  Owns.set_config
end