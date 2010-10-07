
# license is MIT
#
# a state-machine-ish example, inspired by the example at
# http://github.com/qoobaa/transitions

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'volute'

#
# our class

class Book
  include Volute

  attr_accessor :stock
  attr_accessor :discontinued

  attr_reader :state

  def initialize (stock)
    @stock = stock
    @discontinued = false
    @state = :in_stock
  end
end

#
# a volute triggered for any 'set' operation on an attribute of book

volute Book do

  # object.vset(:state, x)
  #   is equivalent to
  # object.instance_variable_set(:@state, x)

  if object.stock <= 0
    object.vset(:state, object.discontinued ? :discontinued : :out_of_stock)
  else
    object.vset(:state, :in_stock)
  end
end

#
# trying

emma = Book.new(10)

emma.stock = 2
p emma.state # => :in_stock

emma.stock = 0
p emma.state # => :out_of_stock

emma.discontinued = true
p emma.state # => :discontinued

