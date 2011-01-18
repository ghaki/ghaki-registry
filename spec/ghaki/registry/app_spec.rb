############################################################################
require 'ghaki/registry/app'

############################################################################
module Ghaki module Registry module AppTesting
  begin
    require 'ghaki/app/engine'
    APP_MOD = Ghaki::App::Engine
    ENG_MOD = Ghaki::Registry::Engine
    describe APP_MOD do

      context 'singleton' do
        subject { APP_MOD.instance }
        it { should respond_to :registry }
      end

      context 'singleton methods' do
        context '#registry' do
          subject { APP_MOD.instance.registry }
          it { should be_an_instance_of(ENG_MOD) }
          it { should equal(ENG_MOD.instance) }
        end
      end

    end
  rescue LoadError
    describe 'Ghaki::App::Engine' do
      pending 'external library not available: <ghaki/app/engine>'
    end
  end
end end end
############################################################################
