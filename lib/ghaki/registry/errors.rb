############################################################################
class Ghaki

  ##########################################################################
  class FeatureDisabledError < RuntimeError
    attr_accessor :feature
    def initialize _feature, msg=nil
      @feature = _feature
      msg ||= 'Feature Disabled: ' + @feature.to_s
      super( msg )
    end
  end

  #-------------------------------------------------------------------------
  class FeatureNotFoundError < RuntimeError
    attr_accessor :feature
    def initialize _feature, msg=nil
      @feature = _feature
       msg ||= 'Feature Not Registered: ' + @feature.to_s
      super(msg)
    end
  end

  ##########################################################################
  class PluginDisabledError < RuntimeError
    attr_accessor :feature, :plugin
    def initialize _feature, _plugin, msg=nil
      @feature = _feature
      @plugin  = _plugin
      msg ||= 'Plugin Disabled: ' + @plugin.to_s
      super(msg)
    end
  end

  #-------------------------------------------------------------------------
  class PluginNotFoundError < RuntimeError
    attr_accessor :feature, :plugin
    def initialize _feature, _plugin, msg=nil
      @feature = _feature
      @plugin  = _plugin
      msg ||= 'Plugin Not Registered: ' + @plugin.to_s
      super(msg)
    end
  end

  #-------------------------------------------------------------------------
  class PluginLoadingError < RuntimeError
    attr_accessor :feature, :plugin, :lib_path, :reason
    def initialize _feature, _plugin, _lib_path, _reason
      @feature  = _feature
      @plugin   = _plugin
      @lib_path = _lib_path
      @reason   = _reason
      msg ||= 'Plugin Loading Error: ' + @reason.to_s
      super(msg)
    end
  end

end
############################################################################
