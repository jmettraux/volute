
# license is MIT

# this example is strongly inspired by the diagnosis example
# for Ruleby ( http://github.com/codeaspects/ruleby )
# but please remember that Ruleby is a Rete implementation and is thus
# vastly superior to what is implemented here

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'volute'


#
# some classes

class Patient

  attr_reader :name

  attr_accessor :fever
  attr_accessor :rash
  attr_accessor :spots
  attr_accessor :sore_throat
  attr_accessor :innoculated

  attr_accessor :diagnosis

  def initialize(name)

    @name = name
    @symptoms = {}
    @innoculated = false
  end

  def diagnose!

    Volute.apply(self)

    @diagnosis
  end
end

#
# the volutes

volute Patient do

  # These volutes are 'state' volutes, they trigger if all the attributes
  # mentioned as keys yield the given value.
  # unlike classical volutes that act as OR, these states volutes have an
  # AND behaviour.

  volute :fever => :high, :spots => :true, :innoculated => true do
    object.diagnosis = 'measles'
    over # prevent further evals
  end
  volute :spots => true do
    object.diagnosis = 'allergy (spots but no measles)'
  end
  volute :rash => true do
    object.diagnosis = 'allergy (rash)'
  end
  volute :sore_throat => true, :fever => :mild do
    object.diagnosis = 'flu'
  end
  volute :sore_throat => true, :fever => :high do
    object.diagnosis = 'flu'
  end
end

pat = Patient.new('alice')
pat.rash = true

puts "#{pat.name} : diagnosed with #{pat.diagnose!}"

pat = Patient.new('bob')
pat.sore_throat = true
pat.fever = :high

puts "#{pat.name} : diagnosed with #{pat.diagnose!}"

