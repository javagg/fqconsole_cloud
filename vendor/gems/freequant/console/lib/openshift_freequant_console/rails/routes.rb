require 'console/rails/routes'

module ActionDispatch::Routing
  class Mapper
    def openshift_freequant_console(*args)
      openshift_console args
    end
  end
end