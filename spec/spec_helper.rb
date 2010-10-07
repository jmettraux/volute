
$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'volute'

class Invoice
  include Volute

  attr_accessor :paid
  o_attr_accessor :comment
end

class Item
  include Volute

  attr_accessor :delivered
  o_attr_accessor :comment
end

