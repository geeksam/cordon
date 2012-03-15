require File.join(File.dirname(__FILE__), 'integration_test_helper')

$shady_method_call_count = 0
module Kernel
  def shady_method
    # we are a hedge. move along.
    $shady_method_call_count += 1
  end
end

# In addition to blacklisting methods, Cordon can also place them on a watchlist.
# This will track invocations for later reporting.
# (It's not nearly as glamorous as the Bond movies would have you believe.)
Cordon.watchlist Kernel, [:shady_method]

class WatchlistTest < CordonUnitTest
  def method_one
    shady_method; @method_one_line = __LINE__
  end
  def method_two
    shady_method; @method_two_line = __LINE__
  end

  def setup
    Cordon.filter_violation_backtrace do |backtrace|
      current_file = File.expand_path(__FILE__)
      in_file = Regexp.new(current_file)
      backtrace.select { |line| line =~ in_file }
    end
  end

  def teardown
    Cordon.dont_filter_violation_backtrace!
    Cordon.incursions.clear
  end

  def test_shady_calls_are_allowed
    method_one; assert_equal 1, $shady_method_call_count
    method_one; assert_equal 2, $shady_method_call_count
    method_two; assert_equal 3, $shady_method_call_count
  end
  
  def test_shady_calls_are_counted
    assert Cordon.incursions.empty?

    method_one; assert_equal 1, Cordon.incursions.length
    method_one; assert_equal 2, Cordon.incursions.length
    method_two; assert_equal 3, Cordon.incursions.length
  end
  
  def test_shady_calls_are_logged
    assert Cordon.incursions.empty?

    method_one; invocation_1_line = __LINE__
    method_one; invocation_2_line = __LINE__
    method_two; invocation_3_line = __LINE__

    i1, i2, i3 = *Cordon.incursions

    # Quick sanity check:  make sure we're only looking at backtraces in the current file (see #setup)
    assert i1.backtrace.length == 2
    assert i2.backtrace.length == 2
    assert i3.backtrace.length == 2

    # NOTE: using assert_match prints a weird MiniTest error

    # First line should be the actual invocation of #shady_method
    assert i1.backtrace[0] =~ /watchlist_test.rb:#{@method_one_line}:in `method_one'$/, i1.backtrace[0]
    assert i2.backtrace[0] =~ /watchlist_test.rb:#{@method_one_line}:in `method_one'$/, i2.backtrace[0]
    assert i3.backtrace[0] =~ /watchlist_test.rb:#{@method_two_line}:in `method_two'$/, i3.backtrace[0]

    # Second line should be the place where method_(one|two) was called
    assert i1.backtrace[1] =~ /watchlist_test.rb:#{invocation_1_line}:in `test_shady_calls_are_logged'$/, i1.backtrace[1]
    assert i2.backtrace[1] =~ /watchlist_test.rb:#{invocation_2_line}:in `test_shady_calls_are_logged'$/, i2.backtrace[1]
    assert i3.backtrace[1] =~ /watchlist_test.rb:#{invocation_3_line}:in `test_shady_calls_are_logged'$/, i3.backtrace[1]
  end
end
