
require File.join(File.dirname(__FILE__), 'spec_helper.rb')


describe "a 'state' volute" do

  describe do

    before(:each) do

      @item = Item.new

      Volute.clear!

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

  describe 'with multiple possible values' do

    before(:each) do

      @i0 = Item.new
      @i1 = Item.new
      @i2 = Item.new

      Volute.clear!

      volute Item do
        volute :weight => [ '1kg', '2kg' ], :delivered => true do
          object.comment = 'delivered an item of 1 or 2 kg'
        end
      end
    end

    it 'should trigger for this or that value' do

      @i0.weight = '1kg'
      @i0.delivered = true
      @i1.weight = '2kg'
      @i1.delivered = true
      @i2.weight = '3kg'
      @i2.delivered = true

      @i0.comment.should == 'delivered an item of 1 or 2 kg'
      @i1.comment.should == 'delivered an item of 1 or 2 kg'
      @i2.comment.should == nil
    end

    it 'should trigger for a plain array value' do

      @i0.weight = [ '1kg', '2kg' ]
      @i0.delivered = true

      @i0.comment.should == 'delivered an item of 1 or 2 kg'
    end
  end

  describe 'with a :not_nil value' do

    before(:each) do

      @item = Item.new

      Volute.clear!

      volute Item do
        volute :weight => '1kg', :delivered => :not_nil do
          object.comment = 'item of 1kg entered delivery circuit'
        end
      end
    end

    it 'should not trigger when nil' do

      @item.weight = '1kg'

      @item.comment.should == nil
    end

    it 'should trigger else' do

      @item.weight = '1kg'
      @item.delivered = false

      @item.comment.should == 'item of 1kg entered delivery circuit'
    end
  end

  # Note : not mentioning an attribute has the same effect as using :any,
  # but when editing in and out, it's easier to change some :any than the
  # whole ":att => :x" thing
  #
  describe 'with an :any value' do

    before(:each) do

      @i0 = Item.new
      @i1 = Item.new
      @i2 = Item.new

      Volute.clear!

      volute Item do
        volute :weight => '1kg', :delivered => :any do
          object.comment = 'item of 1kg'
        end
      end
    end

    it 'should trigger appropriately' do

      @i0.weight = '1kg'
      @i1.weight = '1kg'
      @i2.weight = '2kg'

      #@i0.delivered = nil
      @i1.delivered = true
      @i2.delivered = false

      @i0.comment.should == 'item of 1kg'
      @i1.comment.should == 'item of 1kg'
      @i2.comment.should == nil
    end

    it 'should trigger even if delivered is set' do
    end
  end
end

