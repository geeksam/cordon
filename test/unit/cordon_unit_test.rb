require File.join(File.dirname(__FILE__), *%w[.. helper])

module Kernel
  ExpectationMethodCallReachedKernel = Class.new(Exception)
  def should(*_);     raise ExpectationMethodCallReachedKernel; end
  def should_not(*_); raise ExpectationMethodCallReachedKernel; end
end


# By default, Cordon does nothing!
class CordonDefaultBehaviorUnitTest < Test::Unit::TestCase
  def test_allows_calls_to__should
    assert_raises(ExpectationMethodCallReachedKernel) { Object.new.should }
  end

  def test_allows_calls_to__should_not
    assert_raises(ExpectationMethodCallReachedKernel) { Object.new.should_not }
  end
end

# You can tell Cordon to refuse certain methods on all objects.
class CordonUnitTest < Test::Unit::TestCase
  def setup
    Cordon.refuse :should, :should_not
  end
  def teardown
    Cordon.permit :should, :should_not
  end

  # Calling #should or #should_not on a random object will raise an exception...

  def test_raises_exception_when_calling__should
    assert_raise(Cordon::ExpectationIncursion) { Object.new.should }
  end

  def test_raises_exception_when_calling__should_not
    assert_raise(Cordon::ExpectationIncursion) { Object.new.should_not }
  end

  # ...unless you explicitly wrap that object in an #assert_that call
  
  def test_allows_explicit_calls_to__should
    assert_raises(ExpectationMethodCallReachedKernel) { assert_that(Object.new).should }
  end

  def test_allows_explicit_calls_to__should_not
    assert_raises(ExpectationMethodCallReachedKernel) { assert_that(Object.new).should_not }
  end
end

class CordonPlumbingTest < Test::Unit::TestCase
  def setup
    Cordon.refuse :totally_bogus_method
  end
  def teardown
    Cordon.permit :totally_bogus_method
  end

  def test_assertion_wrapper_responds_to_all_protected_methods
    wrapper = Cordon::AssertionProxy.new(Object.new)
    assert wrapper.respond_to?(:totally_bogus_method)
  end
end
