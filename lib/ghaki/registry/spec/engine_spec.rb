############################################################################
require 'rubygems'
require File.join( File.dirname(__FILE__), '..', 'engine' )
require 'ghaki/rspec_mixin/it_should_respond_to'

############################################################################
class TestPlugin; end

############################################################################
describe Ghaki::Registry::Engine do
  extend Ghaki::RSpecMixin::ItShouldRespondTo

  ##########################################################################
  subject do Ghaki::Registry::Engine.instance end

  ##########################################################################
  after(:each) do
    subject.clear_features
  end

  ##########################################################################
  context 'singleton' do
    it_should_respond_to :subject,
      :features, :clear_features,
      :reserve_feature, :remove_feature,
      :has_feature?, :assert_feature!, :get_feature,
      :enable_feature, :disable_feature, :enabled_feature?,
      :plugins, :clear_plugins,
      :add_plugin, :remove_plugin,
      :has_plugin?, :assert_plugin!, :get_plugin,
      :enable_plugin, :disable_plugin, :enabled_plugin?,
      :failed_plugin?, :plugin_failure,
      :factory_create, :load_plugin
  end

  ##########################################################################
  context 'initial state' do
    it 'should have no features' do
      subject.features.empty?.should == true
    end
  end

  ##########################################################################
  ##########################################################################
  context 'feature normal methods' do

    context '#reserve_feature' do
      it 'should reserve names' do
        subject.reserve_feature :my_feat
        subject.features.keys.length.should == 1
        subject.features.has_key?(:my_feat)
      end
    end

    context '#has_feature?' do
      it 'should see features' do
        subject.reserve_feature :my_feat
        subject.has_feature?(:my_feat).should == true
      end
    end

    context '#assert_feature!' do
      it 'should raise when missing' do
        lambda do
          subject.assert_feature! :mine
        end.should raise_error(Ghaki::FeatureNotFoundError)
      end
      it 'should not raise when present' do
        lambda do
          subject.reserve_feature :mine
          subject.assert_feature! :mine
        end.should_not raise_error(Ghaki::FeatureNotFoundError)
      end
    end

    context '#get_feature' do
      it 'should fetch' do
        subject.reserve_feature :my
        subject.get_feature(:my).class.should == Ghaki::Registry::Feature
        subject.get_feature(:my).name.should == :my
      end
    end

    context '#clear_features' do
      it 'should remove all' do
        subject.reserve_feature :my_reg_a
        subject.reserve_feature :my_reg_b
        subject.clear_features
        subject.has_feature?( :my_reg_a ).should == false
        subject.features.empty?.should == true
      end
    end

    context '#remove_feature' do
      it 'should remove' do
        subject.reserve_feature :my_reg
        subject.remove_feature :my_reg
        subject.has_feature?( :my_reg ).should == false
      end
    end

  end # feat norm meths

  ##########################################################################
  ##########################################################################
  context 'feature delegate methods' do

    before(:each) do
      subject.reserve_feature :duck
    end

    context '#disable_feature' do
      it 'should disable' do
        subject.disable_feature :duck
        subject.enabled_feature?(:duck).should == false
      end
    end

    context '#enable_feature' do
      it 'should enable' do
        subject.disable_feature :duck
        subject.enable_feature :duck
        subject.enabled_feature?(:duck).should == true
      end
    end

    context '#plugins' do
      it 'should have plugins' do
        subject.plugins(:duck).class.should == Hash
        subject.get_feature(:duck).plugins == subject.plugins(:duck)
      end
    end

    context '#get_plugin' do
      it 'should retrieve plugin' do
        subject.add_plugin :my_reg, :my_plugin, TestPlugin
        plug_a = subject.get_feature(:my_reg).get_plugin(:my_plugin)
        plug_b = subject.get_plugin(:my_reg,:my_plugin)
        plug_a.should == plug_b
      end
    end

    context '#add_plugin' do
      it 'should register plugin' do
        subject.add_plugin :my_reg, :my_plugin, TestPlugin
        subject.get_feature(:my_reg).has_plugin?(:my_plugin).should == true
      end
    end

    context '#has_plugin?' do
      it 'should see plugin' do
        subject.add_plugin :my_reg, :my_plugin, TestPlugin
        subject.plugins(:my_reg).has_key?(:my_plugin).should == true
      end
    end

    context '#assert_plugin!' do
      it 'should complain when missing' do
        lambda do
          subject.reserve_feature :my_reg
          subject.assert_plugin! :my_reg, :my_plugin
        end.should raise_error(Ghaki::PluginNotFoundError)
      end
      it 'should not raise when present' do
        lambda do
          subject.add_plugin :my_reg, :my_plugin, TestPlugin
          subject.assert_plugin!  :my_reg, :my_plugin
        end.should_not raise_error(Ghaki::PluginNotFoundError)
      end
    end

    context '#remove_plugin!' do
      it 'should remove' do
        subject.add_plugin :my_reg, :my_plug, TestPlugin
        subject.remove_plugin :my_reg, :my_plug
        subject.has_plugin?( :my_reg, :my_plug ).should == false
      end
    end

    context '#clear_plugins' do
      it 'should remove all plugins' do
        subject.add_plugin :my_reg, :my_plug_a, TestPlugin
        subject.add_plugin :my_reg, :my_plug_b, TestPlugin
        subject.clear_plugins :my_reg
        subject.has_plugin?( :my_reg, :my_plug_a ).should == false
        subject.has_plugin?( :my_reg, :my_plug_b ).should == false
        subject.plugins(:my_reg).empty?
      end
    end

  end # feat del meth

  ##########################################################################
  ##########################################################################
  context 'plugin delegate methods' do

    before(:each) do
      subject.add_plugin :my_reg, :my_plugin, TestPlugin
    end

    context '#enabled_plugin?' do
      it 'should see plugin' do
        subject.enabled_plugin?(:my_reg,:my_plugin).should == true
      end
    end

    context '#disable_plugin' do
      it 'should disable' do
        subject.disable_plugin :my_reg, :my_plugin
        subject.get_feature(:my_reg).get_plugin(:my_plugin).enabled?.should == false
      end
    end

    context '#enable_plugin' do
      it 'should enable' do
        subject.disable_plugin :my_reg, :my_plugin
        subject.enable_plugin :my_reg, :my_plugin
        subject.get_feature(:my_reg).get_plugin(:my_plugin).enabled?.should == true
      end
    end

    context '#factory_create' do
      it 'should create plugin when present' do
        subject.factory_create( :my_reg, :my_plugin ).class.should == TestPlugin
      end
      it 'should complain about missing feature' do
        lambda do
          subject.factory_create( :miss_reg, :my_plugin )
        end.should raise_error(Ghaki::FeatureNotFoundError)
      end
      it 'should complain about missing plugin' do
        lambda do
          subject.factory_create( :my_reg, :miss_plugin )
        end.should raise_error(Ghaki::PluginNotFoundError)
      end

    end

  end # plug del meth

end
############################################################################
