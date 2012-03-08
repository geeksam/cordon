require File.join(File.dirname(__FILE__), 'unit_helper')

module Kernel
  def verboten_method_with_args(*args)
    raise "No args given!" if args.empty?
    raise VerbotenMethodCallReachedKernel, args.inspect
  end

  def verboten_method_with_block(*_)
    raise "Block expected!" unless block_given?
    yield
    raise VerbotenMethodCallReachedKernel
  end

  def verboten_method_with_args_and_block_with_args(options = {})
    raise "No args given!" if options.empty?
    raise "Block expected!" unless block_given?
    arg_for_block = options.fetch(:arg_for_block)
    yield arg_for_block
    raise VerbotenMethodCallReachedKernel, options.inspect
  end
end

Cordon.blacklist Kernel, [:verboten_method, :verboten_method_with_args, :verboten_method_with_block]

class CordonEdgeCaseTests < CordonUnitTest
  # Arguments to verboten methods are passed along as one might expect
  def test_raises_exception_when_calling__verboten_method_with_args
    args = [:foo, :bar, :baz]
    begin
      line = __LINE__; foo.verboten_method_with_args(*args)
    rescue Cordon::Violation => e
      expected = "Kernel#verboten_method_with_args(#{args.map(&:inspect).join(', ')})"
      assert_equal expected, e.message
    rescue VerbotenMethodCallReachedKernel
      flunk "foo.verboten_method_with_args(#{args.map(&:inspect).join(', ')}) should not be allowed! (See line #{line})"
    end
  end

  def test_allows_explicit_calls_to__verboten_method_with_args
    assert_raises(VerbotenMethodCallReachedKernel) do
      assert_that(foo).verboten_method_with_args(:foo, :bar, :baz)
    end
  end

  # And blocks given to verboten methods are yielded to as one might expect
  # Calling #verboten_method_with_block should raise an exception 
  def test_raises_exception_when_calling__verboten_method_with_block
    block_was_called = false
    begin
      line = __LINE__; foo.verboten_method_with_block() { block_was_called = true }
    rescue Cordon::Violation => e
      expected = "Kernel#verboten_method_with_block()"
      assert_equal expected, e.message
      assert_equal false, block_was_called, "Block was called, but it shouldn't have been!"
    rescue VerbotenMethodCallReachedKernel
      flunk "foo.verboten_method_with_block(&b) should not be allowed! (See line #{line})"
    end
  end

  def test_allows_explicit_calls_to__verboten_method_with_block
    block_was_called = false
    assert_raises(VerbotenMethodCallReachedKernel) do
      assert_that(foo).verboten_method_with_block() { block_was_called = true }
    end
    assert block_was_called, "Block wasn't called when it should have been!"
  end

  # Blocks with args get passed the args they expect.
  def test_allows_explicit_calls_to__verboten_method_with_args_and_block_with_args
    block_was_called = false
    arg_passed_to_block = nil
    assert_raises(VerbotenMethodCallReachedKernel) do
      assert_that(foo).verboten_method_with_args_and_block_with_args(:arg_for_block => 42) do |x|
        block_was_called = true
        arg_passed_to_block = x
      end
    end
    assert block_was_called, "Block wasn't called when it should have been!"
    assert_equal 42, arg_passed_to_block
  end
end
