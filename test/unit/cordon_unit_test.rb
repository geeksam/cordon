require File.join(File.dirname(__FILE__), 'unit_helper')

module Kernel
  VerbotenMethodCallReachedKernel = Class.new(Exception)
  def verboten_method(*_)
    raise VerbotenMethodCallReachedKernel
  end
end


# By default, Cordon does nothing!
class CordonDefaultBehaviorUnitTest < Test::Unit::TestCase
  def test_allows_calls_to__verboten_method
    assert_raises(VerbotenMethodCallReachedKernel) { Object.new.verboten_method }
  end
end

# You can tell Cordon to refuse certain methods on all objects.
class CordonUnitTest < Test::Unit::TestCase
  def setup
    Cordon.refuse Kernel, [:verboten_method]
  end

  def foo
    @foo ||= Object.new
  end

  # Calling #verboten_method on a random object will raise an exception...
  def test_raises_exception_when_calling__verboten_method
    assert_raise(Cordon::CordonViolation) do
      foo.verboten_method
    end
  end

  # ...unless you explicitly wrap that object in an #assert_that call
  def test_allows_explicit_calls_to__verboten_method
    assert_raises(VerbotenMethodCallReachedKernel) do
      assert_that(foo).verboten_method
    end
  end

  # ...every time!
  def test_permission_provided_by_assert_that_only_works_once
    assert_raise(Cordon::CordonViolation) do
      begin
        assert_that(foo).verboten_method
      rescue VerbotenMethodCallReachedKernel
        # carry on
      end
      foo.verboten_method
    end
  end
end
