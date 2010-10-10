
require File.join(File.dirname(__FILE__), 'spec_helper.rb')


describe "a 'state' volute" do

  before(:each) do

    Volute.clear!

    @item = Item.new

    volute Item do
      volute :weight => '1kg', :delivered => true do
        object.comment = '1kg and delivered'
      end
      volute :not, :weight => '1kg' do
        object.comment = 'not 1kg'
      end
    end
  end

  it 'should trigger for a given state' do

    @item.weight = '1kg'
    @item.delivered = true

    @item.comment.should == '1kg and delivered'
  end

  it 'should trigger for a :not state' do

    @item.delivered = true

    @item.comment.should == 'not 1kg'
  end
end

