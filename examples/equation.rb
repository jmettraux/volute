
# license is MIT

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'volute'

#
# our class

class Equation
  include Volute

  attr_accessor :km, :h, :kph

  def initialize
    @km = 1.0
    @h = 1.0
    @kph = 1.0
  end

  def inspect

    "#{@km} km, #{@h} h, #{@kph} kph"
  end
end

#
# a volute per attribute

volute Equation do

  # object.vset(:state, x)
  #   is equivalent to
  # object.instance_variable_set(:@state, x)

  volute :km do
    object.vset(:h, value / object.kph)
  end
  volute :h do
    object.vset(:kph, object.km / value)
  end
  volute :kph do
    object.vset(:h, object.km / value)
  end
end

#
# trying

e = Equation.new
p e # => 1.0 km, 1.0 h, 1.0 kph

e.kph = 10.0
p e # => 1.0 km, 0.1 h, 10.0 kph

e.km = 5.0
p e # => 5.0 km, 0.5 h, 10.0 kph

