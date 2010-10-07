
$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'volute'

class Invoice
  include Volute

  attr_accessor :paid
  attr_accessor :comment
end

class Item
  include Volute

  attr_accessor :delivered
  attr_accessor :comment
end

