
require File.join(File.dirname(__FILE__), 'spec_helper.rb')

#volute do
#  volute Invoice do
#    volute :paid do
#
#      if is(true)
#        object.comment = 'got paid'
#      elsif was(nil)
#        object.comment = 'still not paid'
#      end
#    end
#  end
#end

describe 'a volute' do

  before(:each) do

    Volute.clear!

    @invoice = Invoice.new

    volute do
      volute do
        object.comment = [ key, previous_value, value ]
      end
    end
  end

  it 'should not be applied when #instance_variable_set is used' do

    @invoice.instance_variable_set(:@paid, true)

    @invoice.paid.should == true
    @invoice.comment.should == nil
  end

  it 'should not be applied when #volute_do_set is used' do

    @invoice.volute_do_set(:paid, true)

    @invoice.comment.should == nil
  end

  describe 'with no arguments' do

    it 'should be applied for any change' do

      @invoice.paid = true

      @invoice.paid.should == true
      @invoice.comment.should == [ 'paid', nil, true ]
    end
  end
end

describe 'a class without a volute' do

  before(:each) do

    Volute.clear!

    @invoice = Invoice.new
  end

  it 'should get as usual' do

    @invoice.paid.should == nil
  end

  it 'should set as usual' do

    (@invoice.paid = false).should == false
    @invoice.paid.should == false
  end
end

describe 'a volute for a class' do

  before(:each) do

    Volute.clear!

    @invoice = Invoice.new
    @item = Item.new

    volute do
      volute Invoice do
        object.comment = [ key, previous_value, value ]
      end
    end
  end

  it 'should not affect other classes' do

    @invoice.paid = true
    @invoice.comment.should == [ 'paid', nil, true ]
    @item.comment.should == nil
  end
end

