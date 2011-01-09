############################################################################
require 'singleton'
require 'ghaki/registry/errors'
require 'ghaki/registry/feature'

############################################################################
module Ghaki module Registry
  class Engine
    include Singleton

    ########################################################################
    attr_reader :features

    ########################################################################
    def initialize
      clear_features
    end
    def clear_features
      @features = {}
    end

    ########################################################################
    def reserve_feature name
      @features[name] ||= Ghaki::Registry::Feature.new( name )
    end
    def remove_feature name
      @features.delete(name)
    end
    def has_feature? name
      @features.has_key? name
    end
    def assert_feature! name
      raise FeatureNotFoundError.new(name) unless has_feature? name
    end
    def get_feature name
      assert_feature! name
      @features[name]
    end

    ########################################################################
    def enable_feature name
      get_feature(name).enable
    end
    def disable_feature name
      get_feature(name).disable
    end
    def enabled_feature? name
      get_feature(name).enabled?
    end

    ########################################################################
    def plugins feat
      get_feature(feat).plugins
    end
    def add_plugin feat, plug, klass
      reserve_feature(feat).add_plugin( plug, klass )
    end
    def has_plugin? feat, plug
      get_feature(feat).has_plugin? plug
    end
    def assert_plugin! feat, plug
      get_feature(feat).assert_plugin!(plug)
    end
    def remove_plugin feat, plug
      get_feature(feat).remove_plugin(plug) if has_feature?(feat)
    end
    def clear_plugins feat
      get_feature(feat).clear_plugins if has_feature?(feat)
    end
    def load_plugin feat, plug, lib_path
      get_feature(feat).load_plugin(plug,lib_path)
    end
    def get_plugin feat, plug
      get_feature(feat).get_plugin(plug)
    end

    ########################################################################
    def enable_plugin feat, plug
      get_plugin(feat,plug).enable
    end
    def disable_plugin feat, plug
      get_plugin(feat,plug).disable
    end
    def enabled_plugin? feat, plug
      get_plugin(feat,plug).enabled?
    end
    def factory_create feat, plug, *args
      get_plugin(feat,plug).create(*args)
    end
    def plugin_failure feat, plug
      get_plugin(feat,plug).failure
    end
    def failed_plugin? feat, plug
      get_plugin(feat,plug).failed?
    end

  end
end end
############################################################################
