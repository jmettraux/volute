
# license is MIT

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'volute'

#
# our classes

class Light
  include Volute

  attr_accessor :colour
  attr_accessor :changed_at

  def initialize(colour)
    self.colour = colour
  end

  def green?
    self.colour == :green
  end

  def red!
    self.colour = :red
  end
  def green!
    self.colour = :green
  end

  def seconds
    Time.now - @changed_at
  end
end

class Line
  include Volute

  attr_accessor :name
  attr_accessor :cars
  attr_accessor :light
  attr_accessor :complement

  def initialize(name, colour)
    @name = name
    @cars = 0
    @light = Light.new(colour)
  end

  def one_car
    self.cars = self.cars + 1
  end

  def log(message)
    puts "#{@name} : #{message} (#{@cars} cars)"
  end
end


#
# 'business logic'

volute Light do

  volute :colour do
    object.changed_at = Time.now
  end
end

volute Line do

  volute :cars do

    delta = value - object.complement.cars

    if object.light.green?
      object.vset(:cars, value - 1)
      object.log('cars pass')
    else
      if delta > 4 || object.light.seconds > 5
        object.complement.light.red!
        object.light.green!
        object.log('now green')
        object.vset(:cars, 0)
      else
        object.log('car stops')
      end
    end
  end
end

#
# initialize system

north_south = Line.new('north-south', :green)
east_west = Line.new('east-west', :red)

north_south.complement = east_west
east_west.complement = north_south

#
# play

north_south.one_car
east_west.one_car
east_west.one_car
north_south.one_car
east_west.one_car
east_west.one_car
north_south.one_car
east_west.one_car
east_west.one_car
north_south.one_car

