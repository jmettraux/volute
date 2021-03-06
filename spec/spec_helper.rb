
$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'volute'

class Invoice
  include Volute

  attr_accessor :paid
  attr_accessor :customer_name
  attr_accessor :customer_id
  o_attr_accessor :comment
end

class Item
  include Volute

  attr_accessor :weight
  attr_accessor :delivered
  o_attr_accessor :comment
end

class HeavyItem < Item
end

class Package
  include Volute

  attr_accessor :location
  attr_accessor :delivered
  o_attr_accessor :comment
end

class Delivery
  include Volute

  attr_accessor :scheduled
  attr_accessor :performed
  o_attr_accessor :comment
end

module Financing
  class Loan
    include Volute
    attr_accessor :price
    o_attr_accessor :comment
  end
  class Grant
    include Volute
    attr_accessor :price
    o_attr_accessor :comment
  end
end

