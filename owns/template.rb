module Owns
  module Template
    require 'mustache'

    class Zone < Mustache
      self.template_path = File.realpath(File.join(PATHNAME, "assets/templates/"))
      self.template_file = File.realpath(File.join(self.template_path, 'nsd.mustache'))
    end

    class Nsd < Mustache
      self.template_path = File.realpath(File.join(PATHNAME, "assets/templates/"))
      self.template_file = File.realpath(File.join(self.template_path, 'nsd.mustache'))
    end

  end
end