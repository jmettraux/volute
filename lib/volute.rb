#--
# Copyright (c) 2010-2010, John Mettraux, jmettraux@gmail.com
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
# Made in Japan.
#++


# TODO : insert lengthy explanation here
#
module Volute

  VOLUTE_VERSION = '0.1.1'

  #
  # adding class methods to target classes

  def self.included(target)

    target.instance_eval do
      alias o_attr_accessor attr_accessor
    end

    def target.attr_accessor(*args)

      args.each do |arg|
        define_method(arg) { volute_get(arg.to_s) }
        define_method("#{arg}=") { |value| volute_set(arg.to_s, value) }
      end
    end
  end

  #
  # instance methods added to target classes

  def vset(key, value=nil)

    if key.is_a?(Hash)
      key.each { |k, v| instance_variable_set("@#{k}", v) }
    else
      instance_variable_set("@#{key}", value)
    end
  end

  def volute_get(key)

    instance_variable_get("@#{key}")
  end

  def volute_set(key, value)

    previous_value = volute_get(key)
    vset(key, value)
    Volute.root_eval(self, key, previous_value, value)

    value
  end

  #
  # Volute class methods

  def self.register(args, block)

    top << [ args, block ]
  end

  # Nukes all the top level volutes.
  #
  def self.clear!

    @top = nil
  end

  def self.root_eval(object, attribute, previous_value, value)

    target = Target.new(object, attribute, previous_value, value)

    top.each { |args, block| target.volute(*args, &block) }
  end

  def self.top

    (@top ||= VoluteArray.new)
  end

  #
  # some classes

  class VoluteArray < Array

    def filter(arg)

      select { |args, block|

        classes = args.select { |a| a.is_a?(Class) }

        if args.include?(arg)
          true
        elsif arg.is_a?(Class)
          (arg.ancestors & classes).size > 0
        elsif arg.is_a?(Module)
          (arg.constants.collect { |c| arg.const_get(c) } & classes).size > 0
        #elsif arg.is_a?(Symbol)
          # already handled by the initial if
        else
          false
        end
      }
    end

    def remove(arg)

      filtered = filter(arg)

      reject! { |volute| filtered.include?(volute) }
    end
  end

  class Target

    attr_reader :object, :attribute, :previous_value, :value

    def initialize(object, attribute, previous_value, value)

      @object = object
      @attribute = attribute
      @previous_value = previous_value
      @value = value

      @over = false
    end

    def volute(*args, &block)

      return if @over
      return unless match?(args)

      self.instance_eval(&block)
    end

    def over

      @over = true
    end

    #def is(val)
    #  val == value
    #end
    #def was(val)
    #  val == previous_value
    #end

    protected

    def match?(args)

      args.first == :not ? not(do_match?(args[1..-1])) : do_match?(args)
    end

    def do_match?(args)

      return true if args.empty?

      classes = args.select { |a| a.is_a?(Class) }
      args.select { |a| a.is_a?(Module) }.each { |m|
        classes.concat(m.constants.collect { |c| m.const_get(c) })
      }
      return true if (classes & object.class.ancestors).size > 0

      atts = args.select { |a| a.is_a?(Symbol) }
      return true if atts.include?(attribute.to_sym)

      opts = args.last.is_a?(Hash) ? args.pop : {}

      opts.each do |k, v|
        return true if (
          (k == :any || k == previous_value) &&
          (v == :any || v == value)
        )
      end

      false
    end
  end
end

# Registers a 'volute' at the top level (ie a volute not nested into another)
#
def volute(*args, &block)

  Volute.register(args, block)
end

# With no arguments, it will list all the top-level volutes.
#
def volutes(arg=nil)

  arg ? Volute.top.filter(arg) : Volute.top
end

