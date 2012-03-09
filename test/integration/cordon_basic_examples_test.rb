require File.join(File.dirname(__FILE__), 'integration_test_helper')

module Kernel
  def verboten_method
    raise VerbotenMethodCallReachedKernel
  end
end

# You can tell Cordon to blacklist certain methods on all objects.
Cordon.blacklist Kernel, [:verboten_method]

class CordonBasicExamples < CordonUnitTest
  # Calling #verboten_method on an object will raise an exception...
  def test_raises_exception_when_calling__verboten_method
    assert_raise(Cordon::Violation) do
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
    assert_raise(Cordon::Violation) do
      begin
        assert_that(foo).verboten_method
      rescue VerbotenMethodCallReachedKernel
        # carry on
      end
      foo.verboten_method
    end
  end
end

