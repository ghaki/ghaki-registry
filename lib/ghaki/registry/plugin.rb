############################################################################
require 'ghaki/registry/engine'

############################################################################
module Ghaki module Registry
  module Plugin

    ########################################################################
    def set_plugin_registry feat_name, opts={}
      use_simple = if opts.has_key?(:simple_naming) then opts[:simple_naming] else true end
      feat_nick  = if opts.has_key?(:nick_name)     then opts[:nick_name] else feat_name end
      reg_meth   = if use_simple then :register_plugin else :"register_#{feat_nick}_plugin" end
      Ghaki::Registry::Engine.instance.reserve_feature( feat_name )
      (class << self; self; end).instance_eval do
        define_method reg_meth do |reg_item|
          Ghaki::Registry::Engine.instance.add_plugin( feat_name, reg_item, self )
        end
      end
    end

  end
end end
############################################################################
