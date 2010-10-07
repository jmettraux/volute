
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
      object.comment = [ attribute, previous_value, value ]
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

    volute Invoice do
      object.comment = [ attribute, previous_value, value ]
    end
  end

  it 'should affect its class' do

    @invoice.paid = true

    @invoice.comment.should == [ 'paid', nil, true ]
  end

  it 'should not affect other classes' do

    @invoice.paid = true

    @item.comment.should == nil
  end
end


describe 'a volute for two classes' do

  before(:each) do

    Volute.clear!

    @invoice = Invoice.new
    @item = Item.new

    volute Invoice, Item do
      object.comment = [ attribute, previous_value, value ]
    end
  end

  it 'should affect class A' do

    @invoice.paid = true
    @invoice.comment.should == [ 'paid', nil, true ]
  end

  it 'should affect class B' do

    @item.delivered = true
    @item.comment.should == [ 'delivered', nil, true ]
  end
end

describe 'a volute for an attribute' do

  before(:each) do

    Volute.clear!

    @item = Item.new
    @package = Package.new

    volute :delivered do
      object.comment = [ object.class, attribute, previous_value, value ]
    end
  end

  it 'should affect class A' do

    @item.delivered = true

    @item.comment.should == [ Item, 'delivered', nil, true ]
  end

  it 'should affect class B' do

    @package.delivered = true

    @package.comment.should == [ Package, 'delivered', nil, true ]
  end
end

