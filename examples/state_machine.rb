
# license is MIT
#
# a state-machine-ish example, inspired by the example at
# http://github.com/qoobaa/transitions

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'volute'

#
# our classes

module Bookshop

  class Book
    include Volute

    attr_accessor :stock
    attr_accessor :discontinued
    attr_accessor :state

    def initialize (stock)
      @stock = stock
      @discontinued = false
      @state = :in_stock
    end
  end
end

#
# volutes

volute Bookshop do

  volute :stock, :discontinued do

    # anything in the module Bookshop that has an attribute :stock
    # or :discontinued

    if object.stock <= 0
      object.state = object.discontinued ? :discontinued : :out_of_stock
    else
      object.state = :in_stock
    end
  end
end

#
# trying

emma = Bookshop::Book.new(10)

emma.stock -= 8
p emma.state # => :in_stock

emma.stock -= 2
p emma.state # => :out_of_stock

emma.discontinued = true
p emma.state # => :discontinued

