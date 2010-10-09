
require File.join(File.dirname(__FILE__), 'spec_helper.rb')


describe 'a volute with a :not as first arg' do

  before(:each) do

    @item = Item.new
    @invoice = Invoice.new
  end

  describe 'and classes as further args' do

    before(:each) do

      Volute.clear!

      volute :not, Item do
        object.comment = 'not an item'
      end
    end

    it 'should not affect the negated class' do

      @item.weight = '12 pounds'

      @item.comment.should == nil
    end

    it 'should affect other classes' do

      @invoice.paid = true

      @invoice.comment.should == 'not an item'
    end
  end

  describe 'and nothing else' do

    before(:each) do

      Volute.clear!

      volute :not do
        object.comment = 'NEVER !'
      end
    end

    it 'should never trigger' do

      @item.weight = '1kg'

      @item.comment.should == nil
    end
  end
end

