############################################################################
require 'ghaki/registry/service'

############################################################################
module Ghaki module Registry
  class Feature

    ########################################################################
    attr_accessor :name, :plugins

    ########################################################################
    def initialize _name
      @name = _name
      @enabled = true
      @plugins = {}
    end

    ########################################################################
    def to_s; self.name.to_s end

    ########################################################################
    def clear_plugins
      @plugins = {}
    end

    ########################################################################
    def enabled?
      @enabled
    end
    def enable val=true
      @enabled = val
    end
    def disable val=true
      self.enable !val
    end
    def assert_enabled!
      raise FeatureDisabledError.new( self.name ) unless self.enabled?
    end

    ########################################################################
    def add_plugin plugin_name, plugin_class
      @plugins[plugin_name] = Ghaki::Registry::Service.new( self, plugin_name, plugin_class )
    end

    ########################################################################
    def load_plugin plugin_name, lib_path
      begin
        require lib_path
      rescue Exception => e
        @plugins[plugin_name]  = Ghaki::Registry::Service.new( self, plugin_name, nil )
        @plugins[plugin_name].failure = Ghaki::PluginLoadingError.new( self.name, plugin_name, lib_path, e)
        nil
      end
    end

    ########################################################################
    def assert_plugin! plugin_name
      raise PluginNotFoundError.new( self.name, plugin_name ) unless has_plugin? plugin_name
    end
    def get_plugin plugin_name
      assert_plugin! plugin_name
      @plugins[plugin_name]
    end
    def remove_plugin plugin_name
      @plugins.delete plugin_name
    end
    def has_plugin? plugin_name
      @plugins.has_key? plugin_name
    end

    ########################################################################
    def factory_create plugin_name, *args
      get_plugin(plugin_name).create(*args)
    end
    def enabled_plugin? plugin_name
      get_plugin(plugin_name).enabled?
    end
    def disable_plugin plugin_name
      get_plugin(plugin_name).disable
    end
    def enable_plugin plugin_name
      get_plugin(plugin_name).enable
    end

    ########################################################################
    def failed_plugin? plugin_name
      get_plugin(plugin_name).failed?
    end
    def plugin_failure plugin_name
      get_plugin(plugin_name).failure
    end

  end
end end
############################################################################
