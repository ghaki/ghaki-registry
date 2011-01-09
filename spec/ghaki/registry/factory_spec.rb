############################################################################
require 'ghaki/registry/engine'
require 'ghaki/registry/factory'

############################################################################
module Ghaki module Registry module FactoryTesting
  describe Ghaki::Registry::Factory do

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
        DOG_METHODS = [
          :create, :has_plugin?, :add_plugin,
          :enabled_plugin?, :enable_plugin, :disable_plugin,
          :remove_plugin, :clear_plugins, :plugins, :feature,
        ]
        DOG_METHODS.each do |token| it { should respond_to token } end
      end

      ########################################################################
      context 'methods' do

        describe '#create' do
          it 'should make object' do
            DogFactory.create(:rover).class.should == DogPlugin
          end
        end

        describe '#has_plugin?' do
          it 'should see' do
            DogFactory.has_plugin?(:rover).should == true
          end
        end

        describe '#plugins' do
          it 'should have plugins' do
            DogFactory.plugins.class.should == Hash
            DogFactory.plugins.keys.length.should == 1
          end
        end

        describe '#disable_plugins' do
          it 'should disable' do
            DogFactory.disable_plugin(:rover)
            DogFactory.enabled_plugin?(:rover)
          end
        end

        describe '#enable_plugins' do
          it 'should disable' do
            DogFactory.disable_plugin(:rover)
            DogFactory.enable_plugin(:rover)
            DogFactory.enabled_plugin?(:rover)
          end
        end

        describe '#remove_plugin' do
          it 'should remove' do
            DogFactory.remove_plugin(:rover)
            DogFactory.has_plugin?(:rover).should == false
          end
        end

        describe '#feature' do
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
        CAT_METHODS = [
          :create_cat_plugin, :has_cat_plugin?, :add_cat_plugin,
          :enabled_cat_plugin?, :enable_cat_plugin, :disable_cat_plugin,
          :remove_cat_plugin, :clear_cat_plugins, :cat_plugins, :cat_feature,
        ]
        CAT_METHODS.each do |token| it { should respond_to token } end
      end
      
      ########################################################################
      context 'methods' do

        describe '#create_<name>' do
          it 'should create' do
            CatFactory.create_cat_plugin(:felix).class.should == CatPlugin
          end
        end

        describe '#has_plugin_<name>?' do
          it 'should see' do
            CatFactory.has_cat_plugin?(:felix).should == true
          end
        end

        describe '#<name>_plugins' do
          it 'should have plugins' do
            CatFactory.cat_plugins.class.should == Hash
            CatFactory.cat_plugins.keys.length.should == 1
          end
        end

        describe '#disable_<name>_plugin' do
          it 'should disable' do
            CatFactory.disable_cat_plugin(:felix)
            CatFactory.enabled_cat_plugin?(:felix).should == false
          end
        end

        describe '#enable_<name>_plugin' do
          it 'should enable' do
            CatFactory.disable_cat_plugin(:felix)
            CatFactory.enable_cat_plugin(:felix)
            CatFactory.enabled_cat_plugin?(:felix).should == true
          end
        end

        describe '#remove_<name>_plugin' do
          it 'should remove' do
            CatFactory.remove_cat_plugin(:felix)
            CatFactory.has_cat_plugin?(:felix).should == false
          end
        end

        describe '#<name>_feature' do
          it 'should expose feature' do
            CatFactory.cat_feature.class.should == Ghaki::Registry::Feature
          end
        end

      end # complex methods

    end # complex

  end
end end end
############################################################################
