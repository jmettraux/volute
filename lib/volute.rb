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
  VOLUTE_DEPTH = 217

  #
  # adding class methods to target classes

  def self.included(target)

    def target.volute(*args)

      args.each do |arg|
        define_method(arg) { volute_get(arg.to_s) }
        define_method("#{arg}=") { |value| volute_set(arg.to_s, value) }
      end
    end
  end

  #
  # instance methods added to target classes

  def volute_get(key)

    instance_variable_get("@#{key}")
  end

  def volute_set(key, value)

    volutes << [ key, volute_get(key) ]
    while volutes.length > VOLUTE_DEPTH
      volutes.shift
    end
    instance_variable_set("@#{key}", value)
  end

  def volutes

    (Volute.volutes[object_id] ||= [])
  end

  #
  # Volute class methods

  def self.volutes

    @volutes ||= {}
  end
end

#def volute(&block)
#end

