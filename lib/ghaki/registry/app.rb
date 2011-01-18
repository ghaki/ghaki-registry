############################################################################
require 'ghaki/registry/engine'
begin
  require 'ghaki/app/engine'
  Ghaki::App::Engine.class_eval do
    def registry
      Ghaki::Registry::Engine.instance
    end
  end
rescue LoadError
end
############################################################################
