require 'ghaki/app/engine'
require 'ghaki/registry/engine'

Ghaki::App::Engine.class_eval do
  def registry
    Ghaki::Registry::Engine.instance
  end
end
