############################################################################
require 'ghaki/registry/errors'
require 'ghaki/registry/service'

############################################################################
module Ghaki module Registry module ServiceTesting
  describe Ghaki::Registry::Service do

    class TestPlugin; end
    class FakeFeature; end

    ##########################################################################
    before (:each) do
      @service = Ghaki::Registry::Service.new(FakeFeature.new,:my_plugin,TestPlugin)
    end

    ##########################################################################
    subject { @service }

    ##########################################################################
    context 'object' do
      MY_METHODS = [
        :enabled?, :enable, :disable, :assert_enabled!,
        :to_s,
        :failure, :failure=, :failed?, :assert_not_failed!,
        :create, :assert_can_create!,
      ]
      MY_METHODS.each do |token| it { should respond_to token } end
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
      describe '#disable' do
        it 'should disable' do
          subject.disable
          subject.enabled?.should == false
        end
      end

      ########################################################################
      describe '#enable' do
        it 'should enable' do
          subject.disable
          subject.enable
          subject.enabled?.should == true
        end
      end

      ########################################################################
      describe '#assert_enabled!' do
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
      describe '#failed?' do
        it 'should recognize failure' do
          subject.failure = make_loader_failure
          subject.failed?.should == true
        end
      end

      ########################################################################
      describe '#create_plugin' do
        it 'should create plugin when present' do
          subject.create.should be_an_instance_of(TestPlugin)
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
end end end
############################################################################
