############################################################################
require 'rubygems'
require File.join( File.dirname(__FILE__), '..', 'engine' )
require File.join( File.dirname(__FILE__), '..', 'plugin' )
require 'ghaki/rspec_mixin/it_should_respond_to'

############################################################################

############################################################################
describe Ghaki::Registry::Plugin do
  extend Ghaki::RSpecMixin::ItShouldRespondTo

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
      subject do DogBase end
      it_should_respond_to :subject,
        :set_plugin_registry,:register_plugin
    end

    ########################################################################
    context 'child object' do
      subject do DogCollie end
      it_should_respond_to :subject,
        :set_plugin_registry, :register_plugin
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
      subject do CatBase end
      it_should_respond_to :subject,
        :set_plugin_registry,:register_cat_plugin
    end

    ########################################################################
    context 'child object' do
      subject do CatTabby end
      it_should_respond_to :subject,
        :set_plugin_registry, :register_cat_plugin
    end

    ########################################################################
    context 'methods' do
    end # complex methods

  end # complex

end
############################################################################
