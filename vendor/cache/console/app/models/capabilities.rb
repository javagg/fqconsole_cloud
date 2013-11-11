#
# TODO: Patch things up!!! remove them later
#
require "#{Console::Engine.root}/app/models/capabilities"

module Capabilities
  class Cacheable
    def initialize(*args)
      self.class.attrs.each_with_index { |t, i| send("#{t}=", args[i]) }
    end
  end
end


