
require File.join(File.dirname(__FILE__), 'spec_helper.rb')

class Invoice
  include Volute

  volute :paid
end

describe Volute do

  describe 'when included' do

    before(:each) do
      @invoice = Invoice.new
    end

    it 'should grant getters' do
      @invoice.paid.should == nil
    end

    it 'should grants setters' do
      @invoice.paid = true
      @invoice.paid.should == true
    end
  end
end

