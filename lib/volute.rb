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

module Volute

  VOLUTE_VERSION = '0.1.0'

  #
  # adding class methods to target classes

  def self.included(target)

    def target.attr_accessor(*args)

      args.each do |arg|
        define_method(arg) { volute_get(arg.to_s) }
        define_method("#{arg}=") { |value| volute_set(arg.to_s, value) }
      end
    end
  end

  #
  # instance methods added to target classes

  def volute_do_set(key, value)

    instance_variable_set("@#{key}", value)
  end

  def volute_get(key)

    instance_variable_get("@#{key}")
  end

  def volute_set(key, value)

    previous_value = volute_get(key)
    volute_do_set(key, value)
    Volute.root_eval(self, key, previous_value, value)

    value
  end

  #
  # Volute class methods

  def self.<<(block)

    (@top ||= []) << block
  end

  # Nukes all the top level volutes.
  #
  def self.clear!

    (@top = [])
  end

  def self.root_eval(object, key, previous_value, value)

    (@top || []).each do |block|
      Target.new(object, key, previous_value, value).instance_eval(&block)
    end
  end

  #
  # some classes

  class Target

    attr_reader :object, :key, :previous_value, :value

    def initialize(object, key, previous_value, value)

      @object = object
      @key = key
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

    def is(val)

      val == value
    end

    def was(val)

      val == previous_value
    end

    protected

    def match? (args)

      opts = args.last.is_a?(Hash) ? args.pop : {}

      if from = opts[:from]
        return false if previous_value != from
      end
      if to = opts[:to]
        return false if value != from
      end

      args.each do |a|
        if a.is_a?(Class) && ( ! object.class.ancestors.include?(a))
          return false
        end
        if a.is_a?(Symbol) && a.to_s != key
          return false
        end
      end

      true
    end
  end
end

def volute(&block)

  Volute << block
end

