
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

describe 'transition volutes' do

  before(:each) do

    Volute.clear!

    @package = Package.new
    @package.vset(:location, 'NRT')

    volute :location do
      volute :any => 'SFO' do
        object.comment = 'reached SFO'
      end
    end
    volute :location do
      volute  'NRT' => 'SFO' do
        object.comment = 'reached SFO from NRT'
      end
    end
    volute 'NRT' => 'FCO' do
      object.comment = 'reached FCO from NRT'
    end
    volute 'GVA' => :any do
      object.comment = 'left GVA'
    end
  end

  it 'should not trigger when not specified' do

    @package.location = 'ZRH'

    @package.comment.should == nil
  end

  it 'should trigger for an end state' do

    @package.vset(:location, 'ZRH')
    @package.location = 'SFO'

    @package.comment.should == 'reached SFO'
  end

  it 'should trigger for an attribute, a start state and an end state' do

    @package.location = 'SFO'

    @package.comment.should == 'reached SFO from NRT'
  end

  it 'should trigger for a start state and an end state' do

    @package.location = 'FCO'

    @package.comment.should == 'reached FCO from NRT'
  end

  it 'should trigger for a start state' do

    @package.vset(:location, 'GVA')
    @package.location = 'CAL'

    @package.comment.should == 'left GVA'
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

