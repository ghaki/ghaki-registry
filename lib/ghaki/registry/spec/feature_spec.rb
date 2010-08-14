############################################################################
require 'rubygems'
require File.join( File.dirname(__FILE__), '..', 'errors' )
require File.join( File.dirname(__FILE__), '..', 'feature' )
require 'ghaki/rspec_mixin/it_should_respond_to'

############################################################################
class TestPlugin; end

############################################################################
describe Ghaki::Registry::Feature do
  extend Ghaki::RSpecMixin::ItShouldRespondTo

  ##########################################################################
  before (:each) do
    @feature = Ghaki::Registry::Feature.new(:my_feature)
  end

  ##########################################################################
  subject do @feature end

  ##########################################################################
  context 'object' do
    it_should_respond_to :subject,
      :enabled?, :enable, :disable, :assert_enabled!,
      :add_plugin, :remove_plugin, :has_plugin?, :assert_plugin!,
      :plugins, :clear_plugins, :to_s,
      :get_plugin, :factory_create,
      :enable_plugin, :disable_plugin, :enabled_plugin?,
      :load_plugin, :failed_plugin?, :plugin_failure
  end

  ##########################################################################
  ##########################################################################
  context 'initial state' do
    it 'should be enabled' do
      subject.enabled?.should == true
    end
    it 'should be empty' do
      subject.plugins.empty?.should == true
    end
    it '#plugins should be hash' do
      subject.plugins.class.should == Hash
    end
  end

  ##########################################################################
  ##########################################################################
  context 'methods' do

    ########################################################################
    context '#disable' do
      it 'should disable' do
        subject.disable
        subject.enabled?.should == false
      end
    end

    ########################################################################
    context '#enable' do
      it 'should enable' do
        subject.disable
        subject.enable
        subject.enabled?.should == true
      end
    end

    ########################################################################
    context '#assert_enabled!' do
      it 'should not complain when enabled' do
        lambda do
          subject.assert_enabled!
        end.should_not raise_error(Ghaki::FeatureDisabledError)
      end
      it 'should complain when disabled' do
        lambda do
          subject.disable
          subject.assert_enabled!
        end.should raise_error(Ghaki::FeatureDisabledError)
      end
    end

    ########################################################################
    context '#add_plugin' do
      it 'should register plugin' do
        subject.has_plugin?( :my_plugin ).should == false
        subject.add_plugin :my_plugin, TestPlugin
        subject.has_plugin?( :my_plugin ).should == true
        subject.get_plugin(:my_plugin).should_not == nil
      end
    end

    ########################################################################
    context '#assert_plugin!' do
      it 'should complain when missing' do
        lambda do
          subject.assert_plugin! :my_plugin
        end.should raise_error(Ghaki::PluginNotFoundError)
      end
      it 'should not complain when present' do
        lambda do
          subject.add_plugin :my_plugin
          subject.assert_plugin!  :my_plugin
        end.should_not raise_error(Ghaki::PluginNotFoundError)
      end
    end

    ########################################################################
    context '#remove_plugin' do
      it 'should remove' do
        subject.add_plugin :my_plug, TestPlugin
        subject.remove_plugin :my_plug
        subject.has_plugin?( :my_plug ).should == false
        subject.plugins.keys.length == 1
      end
    end

    ########################################################################
    context '#clear_plugins' do
      it 'should remove all plugins' do
        subject.add_plugin :my_plug_a, TestPlugin
        subject.add_plugin :my_plug_b, TestPlugin
        subject.clear_plugins
        subject.has_plugin?( :my_plug_a ).should == false
        subject.has_plugin?( :my_plug_b ).should == false
        subject.plugins.keys.length == 0
      end
    end

    ########################################################################
    context '#load_plugin' do
      it 'should return nil when library load fails' do
        subject.load_plugin( :my_plugin, 'bogus/missing' ).should == nil
      end
    end

    ########################################################################
    context '#plugin_failure' do
      it 'should have error when library load fails' do
        subject.load_plugin( :my_plugin, 'crap/missing' )
        subject.plugin_failure(:my_plugin).class.should == Ghaki::PluginLoadingError
      end
    end
    context '#failed_plugin?' do
      it 'should detect library load failure' do
        subject.load_plugin( :my_plug_bad, 'crap/missing' )
        subject.failed_plugin?(:my_plug_bad).should == true
      end
      it 'should not have a failure if successful' do
        subject.add_plugin( :my_plug_good, TestPlugin )
        subject.failed_plugin?(:my_plug_good).should == false
      end
    end

    ########################################################################
    context '#factory_create' do
      it 'should create plugin when present' do
        subject.add_plugin :my_plugin, TestPlugin
        subject.factory_create( :my_plugin ).class == TestPlugin
      end
      it 'should complain when plugin is missing' do
        lambda do
          subject.factory_create( :my_plugin ).class == TestPlugin
        end.should raise_error(Ghaki::PluginNotFoundError)
      end
      it 'should complain if failed' do
        subject.load_plugin( :my_plugin, 'junk/missing' )
        subject.plugin_failure(:my_plugin).class.should == Ghaki::PluginLoadingError
        lambda do
          subject.factory_create :my_plugin
        end.should raise_error(Ghaki::PluginLoadingError)
      end
    end

  end # meths

  ##########################################################################
  ##########################################################################
  context 'quasi delegated methods' do

    ########################################################################
    context '#enabled_plugin?' do
      it 'should see status' do
        subject.add_plugin :my_plugin, TestPlugin
        subject.enabled_plugin?(:my_plugin).should == true
      end
    end
    ########################################################################
    context '#disable_plugin' do
      it 'should disable' do
        subject.add_plugin :my_plugin, TestPlugin
        subject.disable_plugin :my_plugin
        subject.enabled_plugin?(:my_plugin).should == false
      end
    end
    ########################################################################
    context '#enable_plugin' do
      it 'should enable' do
        subject.add_plugin :my_plugin, TestPlugin
        subject.disable_plugin :my_plugin
        subject.enable_plugin :my_plugin
        subject.enabled_plugin?(:my_plugin).should == true
      end
    end

  end # quasi-delegated meths

end
############################################################################
