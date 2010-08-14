############################################################################
require 'rubygems'
require File.join( File.dirname(__FILE__), '..', 'engine' )
require File.join( File.dirname(__FILE__), '..', 'factory' )
require 'ghaki/rspec_mixin/it_should_respond_to'

############################################################################

############################################################################
describe Ghaki::Registry::Factory do
  extend Ghaki::RSpecMixin::ItShouldRespondTo

  before(:all) do @reg = Ghaki::Registry::Engine.instance end
  after(:each) do @reg.clear_features end

  ##########################################################################
  ##########################################################################
  context 'with simple naming' do

    ########################################################################
    class DogPlugin; end
    class DogFactory
      extend Ghaki::Registry::Factory
      register_feature :dog
      private_class_method :new
    end

    ########################################################################
    before(:each) do @reg.add_plugin(:dog,:rover,DogPlugin) end

    ########################################################################
    context 'objects extended by' do
      subject do DogFactory end
      it_should_respond_to :subject,
        :create, :has_plugin?, :add_plugin,
        :enabled_plugin?, :enable_plugin, :disable_plugin,
        :remove_plugin, :clear_plugins, :plugins, :feature
    end

    ########################################################################
    context 'methods' do

      context '#create' do
        it 'should make object' do
          DogFactory.create(:rover).class.should == DogPlugin
        end
      end

      context '#has_plugin?' do
        it 'should see' do
          DogFactory.has_plugin?(:rover).should == true
        end
      end

      context '#plugins' do
        it 'should have plugins' do
          DogFactory.plugins.class.should == Hash
          DogFactory.plugins.keys.length.should == 1
        end
      end

      context '#disable_plugins' do
        it 'should disable' do
          DogFactory.disable_plugin(:rover)
          DogFactory.enabled_plugin?(:rover)
        end
      end

      context '#enable_plugins' do
        it 'should disable' do
          DogFactory.disable_plugin(:rover)
          DogFactory.enable_plugin(:rover)
          DogFactory.enabled_plugin?(:rover)
        end
      end

      context '#remove_plugin' do
        it 'should remove' do
          DogFactory.remove_plugin(:rover)
          DogFactory.has_plugin?(:rover).should == false
        end
      end

      context '#feature' do
        it 'should expose feature' do
          DogFactory.feature.class.should == Ghaki::Registry::Feature
        end
      end

    end # simple methods

  end # simple

  ##########################################################################
  ##########################################################################
  context 'complex' do

    ########################################################################
    class CatPlugin; end
    class CatFactory
      extend Ghaki::Registry::Factory
      register_feature :cat, :simple_naming => false
      private_class_method :new
    end

    ########################################################################
    before(:each) do @reg.add_plugin(:cat,:felix,CatPlugin) end

    ########################################################################
    context 'objects extended by' do
      subject do CatFactory end
      it_should_respond_to :subject,
        :create_cat_plugin, :has_cat_plugin?, :add_cat_plugin,
        :enabled_cat_plugin?, :enable_cat_plugin, :disable_cat_plugin,
        :remove_cat_plugin, :clear_cat_plugins, :cat_plugins, :cat_feature
    end
    
    ########################################################################
    context 'methods' do

      context '#create_<name>' do
        it 'should create' do
          CatFactory.create_cat_plugin(:felix).class.should == CatPlugin
        end
      end

      context '#has_plugin_<name>?' do
        it 'should see' do
          CatFactory.has_cat_plugin?(:felix).should == true
        end
      end

      context '#<name>_plugins' do
        it 'should have plugins' do
          CatFactory.cat_plugins.class.should == Hash
          CatFactory.cat_plugins.keys.length.should == 1
        end
      end

      context '#disable_<name>_plugin' do
        it 'should disable' do
          CatFactory.disable_cat_plugin(:felix)
          CatFactory.enabled_cat_plugin?(:felix).should == false
        end
      end

      context '#enable_<name>_plugin' do
        it 'should enable' do
          CatFactory.disable_cat_plugin(:felix)
          CatFactory.enable_cat_plugin(:felix)
          CatFactory.enabled_cat_plugin?(:felix).should == true
        end
      end

      context '#remove_<name>_plugin' do
        it 'should remove' do
          CatFactory.remove_cat_plugin(:felix)
          CatFactory.has_cat_plugin?(:felix).should == false
        end
      end

      context '#<name>_feature' do
        it 'should expose feature' do
          CatFactory.cat_feature.class.should == Ghaki::Registry::Feature
        end
      end

    end # complex methods

  end # complex

end
############################################################################
