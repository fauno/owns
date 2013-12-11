require 'rspec/core/rake_task'
require './owns.rb'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

namespace :owns do
  desc "Generate config for NSD"
  task :generate_nsd do
    Owns.generate_nsd
  end

  desc "Generate Zones config for NSD"
  task :create_zones => [:generate_nsd] do
    Owns.create_zones
  end

  desc "Set the config to NSD"
  task :set_config => [:generate_nsd, :create_zones] do
    Owns.set_config
  end
end