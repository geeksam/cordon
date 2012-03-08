require File.join(File.dirname(__FILE__), 'unit_helper')

module Kernel
  def verboten_method_not_on_cordon_watch_list
    raise VerbotenMethodCallReachedKernel
  end
end

# By default, Cordon does nothing!
class CordonDefaultBehaviorUnitTest < CordonUnitTest
  def test_allows_calls_to__verboten_method_not_on_cordon_watch_list
    assert_raises(VerbotenMethodCallReachedKernel) { foo.verboten_method_not_on_cordon_watch_list }
  end
end
