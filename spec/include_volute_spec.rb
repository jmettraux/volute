
require File.join(File.dirname(__FILE__), 'spec_helper.rb')


describe Volute do

  before(:each) do

    @invoice = Invoice.new
    @package = Package.new
  end

  describe 'when included' do

    it 'should grant getters' do

      @invoice.paid.should == nil
    end

    it 'should grants setters' do

      @invoice.paid = true

      @invoice.paid.should == true
    end

    it 'should allow setting in batch' do

      @package.volute_do_set(:location => 'ZRH', :delivered => false)

      @package.location.should == 'ZRH'
      @package.delivered.should == false
    end
  end

  describe 'setters' do

    it 'should return the new value' do

      (@invoice.paid = false).should == false
    end
  end
end

