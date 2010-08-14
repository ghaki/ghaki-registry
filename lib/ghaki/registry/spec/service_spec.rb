############################################################################
require 'rubygems'
require File.join( File.dirname(__FILE__), '..', 'errors' )
require File.join( File.dirname(__FILE__), '..', 'service' )
require 'ghaki/rspec_mixin/it_should_respond_to'

############################################################################
class TestPlugin; end
class FakeFeature; end

############################################################################
describe Ghaki::Registry::Service do
  extend Ghaki::RSpecMixin::ItShouldRespondTo

  ##########################################################################
  before (:each) do
    @service = Ghaki::Registry::Service.new(FakeFeature.new,:my_plugin,TestPlugin)
  end

  ##########################################################################
  subject do @service end

  ##########################################################################
  context 'object' do
    it_should_respond_to :subject,
      :enabled?, :enable, :disable, :assert_enabled!,
      :to_s,
      :failure, :failure=, :failed?, :assert_not_failed!,
      :create, :assert_can_create!
  end

  ##########################################################################
  ##########################################################################
  context 'initial state' do
    it 'should be enabled' do
      subject.enabled?.should == true
    end
    it 'should stringify properly as name' do
      subject.to_s.should == subject.name.to_s
    end
    it 'should not be failed' do
      subject.failure.should == nil
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
      it 'should complain when disabled' do
        lambda do
          subject.disable
          subject.assert_enabled!
        end.should raise_error(Ghaki::PluginDisabledError)
      end
    end

    def make_loader_failure
      Ghaki::PluginLoadingError.new( :my_feature, :my_plugin,
        'bad/mojo', RuntimeError.new('Bad Mojo') )
    end

    ########################################################################
    context '#failed?' do
      it 'should recognize failure' do
        subject.failure = make_loader_failure
        subject.failed?.should == true
      end
    end

    ########################################################################
    context '#create_plugin' do
      it 'should create plugin when present' do
        subject.create.class.should == TestPlugin
      end
      it 'should complain when plugin is disabled' do
        lambda do
          subject.disable
          subject.create
        end.should raise_error(Ghaki::PluginDisabledError)
      end
    end

  end # meths

end
############################################################################
