
# license is MIT

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'volute' # gem install volute

class Light
  include Volute

  attr_accessor :colour
  attr_accessor :changed_at
end

volute Light do
  volute :colour do
    object.changed_at = Time.now
  end
end

l = Light.new
p l # => #<Light:0x10014c480>

l.colour = :blue
l.colour = :red
p l # => #<Light:0x10014c480 @changed_at=Fri Oct 08 20:01:52 +0900 2010, @colour=:blue>

