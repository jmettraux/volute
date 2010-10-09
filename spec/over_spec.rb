
require File.join(File.dirname(__FILE__), 'spec_helper.rb')


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

