
# license is MIT

# this example is strongly inspired by the diagnosis example
# for Ruleby ( http://github.com/codeaspects/ruleby )
# but please remember that Ruleby is a Rete implementation and is thus
# vastly superior to what is implemented here

# NOTE : this example doesn't work for now, it's an exploration

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'volute'


#
# some classes

class Patient

  attr_reader :name
  attr_reader :symptoms, {}
  attr_accessor :innoculated, false
  attr_accessor :diagnosis

  def initialize(name)

    @name = name
  end

  def diagnose!

    Volute.apply(self)

    @diagnosis
  end

  def method_missing (m, *args)

    if args.length == 0
      @symptoms[m.to_sym]
    else
      super
    end
  end
end

#
# the volutes

volute Patient do
  volute :state, :fever => :high, :spots => :true, :innoculated => true do
    object.diagnosis = 'measles'
    over # prevent further evals
  end
  volute :state, :spots => :true do
    object.diagnosis = 'allergy (spots but no measles)'
  end
  volute :state, :rash => :true do
    object.diagnosis = 'allergy (rash)'
  end
  volute :state, :sore_throat => true, :fever => :mild do
    object.diagnosis = 'flu'
  end
  volute :state, :sore_throat => true, :fever => :high do
    object.diagnosis = 'flu'
  end
end

