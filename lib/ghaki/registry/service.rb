############################################################################
require 'ghaki/registry/errors'

############################################################################
class Ghaki; module Registry
  class Service

    ########################################################################
    attr_accessor :name, :feature, :klass, :failure

    ########################################################################
    def initialize _feature, _name, _klass
      @feature = _feature
      @name = _name
      @klass = _klass
      @enabled = true
      @failure = nil
    end

    ########################################################################
    def to_s; @name.to_s end

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
      raise PluginDisabledError.new( @feature, @name ) unless enabled?
    end

    ########################################################################
    def failed?
      !@failure.nil?
    end
    def assert_not_failed!
      raise @failure if failed?
    end

    ########################################################################
    def assert_can_create!
      assert_not_failed!
      assert_enabled!
    end
    def create *args
      assert_can_create!
      return @klass.new( *args )
    end
    
  end
end end
############################################################################
