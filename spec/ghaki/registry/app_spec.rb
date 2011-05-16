############################################################################
require 'ghaki/app/engine'
require 'ghaki/registry/app'

module Ghaki module Registry module AppTesting
  APP_MOD = Ghaki::App::Engine
  ENG_MOD = Ghaki::Registry::Engine
describe APP_MOD do

  context 'singleton' do
    subject { APP_MOD.instance }
    it { should respond_to :registry }
    context '#registry' do
      subject { APP_MOD.instance.registry }
      it { should be_an_instance_of(ENG_MOD) }
      it { should equal(ENG_MOD.instance) }
    end
  end

end
end end end
############################################################################
