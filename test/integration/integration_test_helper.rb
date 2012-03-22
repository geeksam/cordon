require File.join(File.dirname(__FILE__), *%w[.. helper])
require 'test/unit'

module Kernel
  VerbotenMethodCallReachedKernel = Class.new(Exception)

  def __debug_print__(*args)
    return unless $debug
    puts '', *args
  end
end

class CordonUnitTest < Test::Unit::TestCase
  def foo
    @foo ||= Object.new
  end

  def refute(predicate, *other_args)
    assert !predicate, *other_args
  end
end
