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
    Volute.apply(self, key, previous_value, value)

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

  # Volute.apply is generally called from the setter of a class which include
  # Volute, but it's OK to call it directly, to force volute application.
  #
  #   class Engine
  #     attr_accessor :state
  #     def turn_key!
  #       @key_turned = true
  #       Volute.apply(self, :key_turned)
  #     end
  #     def press_red_button!
  #       Volute.apply(self)
  #     end
  #   end
  #
  #   volute Engine do
  #     if attribute == :key_turned
  #       object.state = :running
  #     else
  #       object.state = :off
  #     end
  #   end
  #
  def self.apply(object, attribute=nil, previous_value=nil, value=nil)

    target = Target.new(object, attribute, previous_value, value)

    top.each { |args, block| target.volute(*args, &block) }
  end

  def self.top

    (@top ||= VoluteArray.new)
  end

  #
  # some classes

  # Subclassing Array to add a #filter and a #remove method, so that
  # things like
  #
  #   all_the_volutes = volutes
  #   volutes_about_class_x = volutes(x)
  #
  #   volutes.remove(x)
  #     # just removed all the volutes referring class or attribute x
  #
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

      match = (args.first == :not) ? ( ! match?(args[1..-1])) : match?(args)
      return unless match

      self.instance_eval(&block)
    end

    def over

      @over = true
    end

    protected

    def match?(args)

      return true if args.empty?

      return state_match?(args) if is_a_state_match?(args)

      classes = args.select { |a| a.is_a?(Class) }
      args.select { |a| a.is_a?(Module) }.each { |m|
        classes.concat(m.constants.collect { |c| m.const_get(c) })
      }
      return true if (classes & @object.class.ancestors).size > 0

      atts = args.select { |a| a.is_a?(Symbol) }
      return true if atts.include?(attribute.to_sym)

      atts = args.select { |a| a.is_a?(Regexp) }
      return true if atts.find { |r| r.match(attribute.to_s) }

      return transition_match?(args.last) if args.last.is_a?(Hash)

      false
    end

    def has_attribute?(att)

      return false if att == :any

      #m = @object.method(att) rescue nil
      #return false unless m
      #return false if m.arity != -1
        # arity would be -1 on ruby 1.8.7 and 0 on ruby 1.9.1, ...

      begin
        @object.send(att)
        true
      rescue NoMethodError => nme
        false
      end
    end

    def is_a_state_match?(args)

      state = args.first

      return false if args.length != 1
      return false unless state.is_a?(Hash)
      return false if state.keys.find { |arg| ! arg.is_a?(Symbol) }
      return false if state.keys.find { |att| ! has_attribute?(att) }
      true
    end

    def val_match?(target, current, in_array=false)

      return true if target == current
      return true if target == :any
      return current != nil if target == :not_nil

      if target.is_a?(Regexp) && current.is_a?(String)
        return target.match(current)
      end
      if in_array == false && target.is_a?(Array)
        return target.find { |t| val_match?(t, current, true) }
      end

      false
    end

    def state_match?(args)

      args.first.each do |att, target_val|
        return false unless val_match?(target_val, @object.send(att))
      end
      true
    end

    def transition_match?(hash)

      hash.each do |startv, endv|
        if val_match?(startv, previous_value) && val_match?(endv, value)
          return true
        end
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

