############################################################################
require 'ghaki/registry/plugin'
require 'ghaki/registry/engine'

############################################################################
module Ghaki module Registry module PluginTesting
  describe Ghaki::Registry::Plugin do

    before(:all) do @reg = Ghaki::Registry::Engine.instance end
    after(:each) do @reg.clear_features end

    ##########################################################################
    ##########################################################################
    context 'with simple naming' do

      ########################################################################
      class DogBase
        extend Ghaki::Registry::Plugin
        set_plugin_registry :dog
      end
      class DogCollie < DogBase
        register_plugin :collie
      end

      ########################################################################
      context 'base object' do
        subject { DogBase }
        it { should respond_to :set_plugin_registry }
        it { should respond_to :register_plugin }
      end

      ########################################################################
      context 'child object' do
        subject { DogCollie }
        it { should respond_to :set_plugin_registry }
        it { should respond_to :register_plugin }
      end

      ########################################################################
      context 'methods' do
      end # simple methods

    end # simple

    ##########################################################################
    ##########################################################################
    context 'complex' do

      ########################################################################
      class CatBase
        extend Ghaki::Registry::Plugin
        set_plugin_registry :cat, :simple_naming => false
      end
      class CatTabby < CatBase
        register_cat_plugin :tabby
      end

      ########################################################################
      context 'base object' do
        subject { CatBase }
        it { should respond_to :set_plugin_registry }
        it { should respond_to :register_cat_plugin }
      end

      ########################################################################
      context 'child object' do
        subject { CatTabby }
        it { should respond_to :set_plugin_registry }
        it { should respond_to :register_cat_plugin }
      end

      ########################################################################
      context 'methods' do
      end # complex methods

    end # complex

  end
end end end
############################################################################
