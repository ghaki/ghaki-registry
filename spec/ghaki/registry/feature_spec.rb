############################################################################
require 'ghaki/registry/feature'

############################################################################
module Ghaki module Registry module FeatureTesting
  describe Ghaki::Registry::Feature do

    class TestPlugin
    end

    ########################################################################
    before (:each) do
      @feature = Ghaki::Registry::Feature.new(:my_feature)
    end

    ########################################################################
    subject do @feature end

    ########################################################################
    context 'object' do
      MY_METHODS = [
        :enabled?, :enable, :disable, :assert_enabled!,
        :add_plugin, :remove_plugin, :has_plugin?, :assert_plugin!,
        :plugins, :clear_plugins, :to_s,
        :get_plugin, :factory_create,
        :enable_plugin, :disable_plugin, :enabled_plugin?,
        :load_plugin, :failed_plugin?, :plugin_failure,
      ]
      MY_METHODS.each do |token| it { should respond_to token } end
    end

    ########################################################################
    ########################################################################
    context 'initial state' do
      it 'should be enabled' do
        subject.enabled?.should be_true
      end
      it 'should be empty' do
        subject.plugins.empty?.should be_true
      end
      it '#plugins should be hash' do
        subject.plugins.should be_an_instance_of(::Hash)
      end
    end

    ########################################################################
    ########################################################################
    context 'methods' do

      ######################################################################
      describe '#disable' do
        it 'should disable' do
          subject.disable
          subject.enabled?.should be_false
        end
      end

      ######################################################################
      describe '#enable' do
        it 'should enable' do
          subject.disable
          subject.enable
          subject.enabled?.should be_true
        end
      end

      ######################################################################
      describe '#assert_enabled!' do
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

      ######################################################################
      describe '#add_plugin' do
        it 'should register plugin' do
          subject.add_plugin :my_plugin, TestPlugin
          subject.has_plugin?( :my_plugin ).should be_true
          subject.get_plugin(:my_plugin).should_not be_nil
        end
      end

      ######################################################################
      describe '#assert_plugin!' do
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

      ######################################################################
      describe '#remove_plugin' do
        it 'should remove' do
          subject.add_plugin :my_plug_a, TestPlugin
          subject.add_plugin :my_plug_b, TestPlugin
          subject.remove_plugin :my_plug_a
          subject.has_plugin?( :my_plug_a ).should be_false
          subject.has_plugin?( :my_plug_b ).should be_true
          subject.plugins.keys.length.should == 1
        end
      end

      ######################################################################
      describe '#clear_plugins' do
        it 'should remove all plugins' do
          subject.add_plugin :my_plug_a, TestPlugin
          subject.add_plugin :my_plug_b, TestPlugin
          subject.clear_plugins
          subject.has_plugin?( :my_plug_a ).should be_false
          subject.has_plugin?( :my_plug_b ).should be_false
          subject.plugins.keys.empty?.should be_true
        end
      end

      ######################################################################
      describe '#load_plugin' do
        it 'should return nil when library load fails' do
          subject.load_plugin( :my_plugin, 'bogus/missing' ).should be_nil
        end
      end

      ######################################################################
      describe '#plugin_failure' do
        it 'should have error when library load fails' do
          subject.load_plugin( :my_plugin, 'crap/missing' )
          subject.plugin_failure(:my_plugin).should be_an_instance_of(Ghaki::PluginLoadingError)
        end
      end
      describe '#failed_plugin?' do
        it 'should detect library load failure' do
          subject.load_plugin( :my_plug_bad, 'crap/missing' )
          subject.failed_plugin?(:my_plug_bad).should be_true
        end
        it 'should not have a failure if successful' do
          subject.add_plugin( :my_plug_good, TestPlugin )
          subject.failed_plugin?(:my_plug_good).should be_false
        end
      end

      ######################################################################
      describe '#factory_create' do
        it 'should create when plugin is present' do
          subject.add_plugin :my_plugin, TestPlugin
          subject.factory_create( :my_plugin ).should be_an_instance_of(TestPlugin)
        end
        it 'should complain when plugin is not specified' do
          lambda do
              subject.factory_create( :my_plugin )
          end.should raise_error(Ghaki::PluginNotFoundError)
        end
        it 'should complain when plugin is invalid' do
          subject.load_plugin( :my_plugin, 'junk/missing' )
          lambda do
                subject.factory_create :my_plugin
          end.should raise_error(Ghaki::PluginLoadingError)
        end
      end

    end # meths

    ########################################################################
    ########################################################################
    context 'quasi delegated methods' do

      ######################################################################
      describe '#enabled_plugin?' do
        it 'should see status' do
          subject.add_plugin :my_plugin, TestPlugin
          subject.enabled_plugin?(:my_plugin).should be_true
        end
      end
      ######################################################################
      describe '#disable_plugin' do
        it 'should disable' do
          subject.add_plugin :my_plugin, TestPlugin
          subject.disable_plugin :my_plugin
          subject.enabled_plugin?(:my_plugin).should be_false
        end
      end
      ######################################################################
      describe '#enable_plugin' do
        it 'should enable' do
          subject.add_plugin :my_plugin, TestPlugin
          subject.disable_plugin :my_plugin
          subject.enable_plugin :my_plugin
          subject.enabled_plugin?(:my_plugin).should be_true
        end
      end

    end # quasi-delegated meths

  end
end end end
############################################################################
