require File.join(File.dirname(__FILE__), 'integration_test_helper')

module Kernel
  def should_probably(*_)
    raise VerbotenMethodCallReachedKernel
  end
end

Cordon.blacklist Kernel, [:should_probably]


# You can specify a different method than #assert_that as your custom assertion wrapper
Cordon.wrap_assertions_with :if_you_would_be_so_kind

class CordonCustomizationExamples < CordonUnitTest
  def test_raises_exception_when_calling__verboten_method
    assert_raise(Cordon::Violation) do
      foo.should_probably :explode
    end
  end

  # ...unless you explicitly wrap that object in an #assert_that call
  def test_allows_explicit_calls_to__verboten_method
    assert_raises(VerbotenMethodCallReachedKernel) do
      if_you_would_be_so_kind(foo).should_probably :work # but only if you feel like it
    end
  end
end

