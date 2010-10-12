
require File.join(File.dirname(__FILE__), 'spec_helper.rb')


describe 'transition volutes' do

  describe 'from that value to this value' do

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

  describe 'with this or that transition' do

    before(:each) do

      Volute.clear!

      volute :location do
        volute :any => 'SFO', 'SFO' => 'GVA' do
          object.comment = 'reached SFO or GVA from SFO'
        end
      end
    end

    it 'should trigger appropriately' do

      p0 = Package.new
      p1 = Package.new
      p2 = Package.new

      p0.location = 'SFO'
      p1.location = 'SFO'
      p1.location = 'GVA'
      p2.location = 'NRT'

      p0.comment.should == 'reached SFO or GVA from SFO'
      p1.comment.should == 'reached SFO or GVA from SFO'
      p2.comment.should == nil
    end
  end

  describe 'with multiple start or end values' do

    before(:each) do

      Volute.clear!

      volute :location do
        volute :any => [ 'ZRH', 'FRA' ] do
          object.comment = 'reached ZRH or FRA'
        end
        volute [ 'NRT', 'SHA' ] => :any do
          object.comment = 'left NRT or SHA'
        end
      end
    end

    it 'should trigger for this or that new (current) value' do

      p0 = Package.new
      p1 = Package.new
      p2 = Package.new

      p0.location = 'ZRH'
      p1.location = 'FRA'
      p2.location = 'NRT'

      p0.comment.should == 'reached ZRH or FRA'
      p1.comment.should == 'reached ZRH or FRA'
      p2.comment.should == nil
    end

    it 'should trigger for this or that previous value' do

      p0 = Package.new
      p1 = Package.new
      p2 = Package.new

      p0.vset(:location, 'NRT')
      p1.vset(:location, 'SHA')
      p2.vset(:location, 'FRA')

      p0.location = 'CDG'
      p1.location = 'CDG'
      p2.location = 'CDG'

      p0.comment.should == 'left NRT or SHA'
      p1.comment.should == 'left NRT or SHA'
      p2.comment.should == nil
    end
  end

  describe 'with /regex/' do

    before(:each) do

      Volute.clear!

      @p0 = Package.new
      @p1 = Package.new
      @p2 = Package.new

      volute :location do
        volute :any => /^S..$/ do
          object.comment = 'reached S..'
        end
        volute /^F..$/ => :any do
          object.comment = 'left F..'
        end
      end
    end

    it 'should trigger appropriately for end values' do

      @p0.location = 'SHA'
      @p1.location = 'SFO'
      @p2.location = 'FRA'

      @p0.comment.should == 'reached S..'
      @p1.comment.should == 'reached S..'
      @p2.comment.should == nil
    end

    it 'should trigger appropriately for start values' do

      @p0.location = 'FRA'
      @p1.location = 'FDH'
      @p2.location = 'ZRH'

      @p0.location = 'VEE'
      @p1.location = 'VIC'
      @p2.location = 'GVA'

      @p0.comment.should == 'left F..'
      @p1.comment.should == 'left F..'
      @p2.comment.should == nil
    end
  end
end

