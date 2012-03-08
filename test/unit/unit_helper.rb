require File.join(File.dirname(__FILE__), *%w[.. helper])
require 'test/unit'
require 'mocha' # require after test/unit

module Kernel
  VerbotenMethodCallReachedKernel = Class.new(Exception)
end

class CordonUnitTest < Test::Unit::TestCase
  def foo
    @foo ||= Object.new
  end

  def refute(predicate, *other_args)
    assert !predicate, *other_args
  end
end
