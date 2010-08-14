############################################################################
require 'ghaki/registry/engine'

############################################################################
class Ghaki; module Registry
  module Factory

    ########################################################################
    def register_feature feat_name, opts={}
      use_simple = if opts.has_key?(:simple_naming) then opts[:simple_naming] else true end
      feat_nick  = if opts.has_key?(:nick_name) then opts[:nick_name] else feat_name end

      feat_and_plug_map = {
        :has_plugin?     =>     :"has_#{feat_nick}_plugin?",
        :enable_plugin   =>  :"enable_#{feat_nick}_plugin",
        :enabled_plugin? => :"enabled_#{feat_nick}_plugin?",
        :disable_plugin  => :"disable_#{feat_nick}_plugin",
        :remove_plugin   =>  :"remove_#{feat_nick}_plugin",
      }

      just_feat_map = {
        :clear_plugins => :"clear_#{feat_nick}_plugins",
        :plugins       =>       :"#{feat_nick}_plugins",
      }

      Ghaki::Registry::Engine.instance.reserve_feature(feat_name)

      (class << self; self; end).instance_eval do

        feat_and_plug_map.each_pair do |simple,complex|
          fac_meth = if use_simple then simple else complex end
          define_method fac_meth do |plug_name|
            Ghaki::Registry::Engine.instance.send( simple, feat_name, plug_name )
          end
        end

        just_feat_map.each_pair do |simple,complex|
          fac_meth = if use_simple then simple else complex end
          define_method fac_meth do
            Ghaki::Registry::Engine.instance.send( simple, feat_name )
          end
        end

        fac_meth = if use_simple then :feature else :"#{feat_nick}_feature" end
        define_method fac_meth do
          Ghaki::Registry::Engine.instance.get_feature( feat_name )
        end

        fac_meth = if use_simple then :create else :"create_#{feat_nick}_plugin" end
        define_method fac_meth do |plug_name,*args|
          Ghaki::Registry::Engine.instance.factory_create( feat_name, plug_name, *args )
        end

        fac_meth = if use_simple then :add_plugin else :"add_#{feat_nick}_plugin" end
        define_method fac_meth do |plug_name,klass|
          Ghaki::Registry::Engine.instance.add_plugin( feat_name, plug_name, klass )
        end

      end # inst eval

    end # def reg

  end # class
end end # namespace
############################################################################
