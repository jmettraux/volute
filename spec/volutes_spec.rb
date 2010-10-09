
require File.join(File.dirname(__FILE__), 'spec_helper.rb')


describe 'volutes' do

  before(:each) do

    Volute.clear!

    volute Invoice do
    end
    volute Package do
    end
    volute Financing::Loan do
    end
    volute Financing::Grant do
    end
    volute Financing do
    end
    volute :delivered do
    end
    volute :not, Financing do
    end
  end

  it 'should return an empty array when there are no volutes' do

    Volute.clear!

    volutes.should == []
  end

  it 'should list volutes' do

    volutes.size.should == 7
  end

  it 'should be updatable' do

    financing = volutes(Financing)
    volutes.reject! { |v| financing.include?(v) }

    volutes.size.should == 3
  end

  it 'should be removable' do

    volutes.remove(Financing)

    volutes.size.should == 3
  end

  describe 'with a class argument' do

    it 'should list only the top-level volutes for that class' do

      volutes(Invoice).size.should == 1
    end
  end

  describe 'with a module argument' do

    it 'should list only the top-level volutes for classes of that module' do

      volutes(Financing).size.should == 4
    end
  end

  describe 'with an :attribute argument' do

    it 'should list only the top-level volutes for that argument' do

      volutes(:delivered).size.should == 1
    end
  end

  describe 'with a :not as first arg' do

    it 'should simply ignore the :not' do

      volutes(Financing).size.should == 4
    end

    it 'should list :not volutes' do

      volutes(:not).size.should == 1
    end
  end
end

