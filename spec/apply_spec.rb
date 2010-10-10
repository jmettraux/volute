
require File.join(File.dirname(__FILE__), 'spec_helper.rb')


class Engine
  attr_accessor :state

  def turn_key!
    @key_turned = true
    Volute.apply(self, :key_turned)
  end

  def press_red_button!
    Volute.apply(self)
  end
end


describe 'Volute.apply' do

  before(:each) do

    Volute.clear!

    volute Engine do
      if attribute == :key_turned
        object.state = :running
      else
        object.state = :off
      end
    end

    @engine = Engine.new

    volute Package do
      volute do
        over if object.delivered
      end
      volute :location do
        (object.comment ||= []) << value
      end
    end
  end

  it 'should apply volutes' do

    @engine.turn_key!

    @engine.state.should == :running
  end
end

