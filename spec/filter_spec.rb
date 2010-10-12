
require File.join(File.dirname(__FILE__), 'spec_helper.rb')


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

describe 'a volute for a module' do

  before(:each) do

    Volute.clear!

    @invoice = Invoice.new

    @loan = Financing::Loan.new
    @grant = Financing::Grant.new

    volute Financing do
      object.comment = [ object.class, attribute, previous_value, value ]
    end
  end

  it 'should not affect classes in other modules' do

    @invoice.paid = false

    @invoice.comment.should == nil
  end

  it 'should affect class A' do

    @loan.price = '1 kopek'

    @loan.comment.should == [ Financing::Loan, 'price', nil, '1 kopek' ]
  end

  it 'should affect class B' do

    @grant.price = '1 cruzeiro'

    @grant.comment.should == [ Financing::Grant, 'price', nil, '1 cruzeiro' ]
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

describe 'a volute for a class or an attribute' do

  before(:each) do

    Volute.clear!

    @item = Item.new
    @package = Package.new

    volute Item, :delivered do
      object.comment = 'Item, :delivered'
    end
  end

  it 'should not trigger inappropriately' do

    @package.location = 'Baden Baden'

    @package.comment.should == nil
  end

  it 'should trigger for the class' do

    @item.weight = :heavy

    @item.comment.should == 'Item, :delivered'
  end

  it 'should trigger for the attribute' do

    @package.delivered = true

    @package.comment.should == 'Item, :delivered'
  end
end

describe 'a volute for a class' do

  before(:each) do

    Volute.clear!

    @item = Item.new
    @heavy_item = HeavyItem.new

    volute Item do
      (object.comment ||= []) << 'regular'
    end
    volute HeavyItem do
      (object.comment ||= []) << 'heavy'
    end
  end

  it 'should trigger for a child class' do

    @heavy_item.delivered = true

    @heavy_item.comment.should == [ 'regular', 'heavy' ]
  end
end

describe 'a volute with a regex arg' do

  before(:each) do

    Volute.clear!

    @invoice = Invoice.new

    volute /^customer_/ do
      object.comment = 'set on customer_ attribute called'
    end
  end

  it 'should not trigger for attributes whose name doesn\'t match' do

    @invoice.paid = true

    @invoice.comment.should == nil
  end

  it 'should trigger for attributes whose name matches' do

    @invoice.customer_name = 'tojo'

    @invoice.comment.should == 'set on customer_ attribute called'
  end
end

