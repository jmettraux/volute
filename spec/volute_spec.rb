
require File.join(File.dirname(__FILE__), 'spec_helper.rb')


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

describe 'a volute with an over' do

  before(:each) do

    Volute.clear!

    @package = Package.new

    volute Package do
      volute do
        over if object.delivered
      end
      volute :location do
        (object.comment ||= []) << value
      end
    end
  end

  it 'should prevent evaluation of further volutes' do

    @package.location = 'ZRH'
    @package.location = 'CDG'

    @package.comment.should == %w[ ZRH CDG ]

    @package.delivered = true
    @package.location = 'FCO'

    @package.comment.should == %w[ ZRH CDG ]
  end
end

