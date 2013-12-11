require 'spec_helper'

describe Owns do
  it 'Generates NSD config' do
    Owns.generate_nsd
    File.exist?(File.realpath('out/nsd.conf')).should be_true
  end

  it 'Creates zones' do
    pending 'generate custom config to test if it generates data'
  end

  it 'Sets its config' do
    pending "don't know how to make a test for Owns#set_config"
  end
end

describe Owns::Utils do
  it 'gets a valid bin file' do
    Owns::Utils.get_bin('ls').should_not be_nil
  end

  it 'gets a valid ip address' do
    ip = Owns::Utils.get_public_address()
    ip_regexp = /^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/
    expect( !!(ip =~ ip_regexp) ).to be_true

    pending "test for ipv6?"
  end

  it 'runs proccesses' do
    expect(Owns::Utils.run_process('echo true')).to be_nil
  end
end