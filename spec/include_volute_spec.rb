
require File.join(File.dirname(__FILE__), 'spec_helper.rb')

class Invoice
  include Volute

  volute :paid
end

describe Volute do

  before(:each) do
    @invoice = Invoice.new
  end

  describe 'when included' do

    it 'should grant getters' do
      @invoice.paid.should == nil
    end

    it 'should grants setters' do
      @invoice.paid = true
      @invoice.paid.should == true
    end
  end

  describe 'setters' do

    it 'should return the new value' do
      (@invoice.paid = false).should == false
    end
  end
end

