require File.join(File.dirname(__FILE__), 'integration_test_helper')

module Kernel
  def good_context
    yield
  end

  def bad_context
    yield
  end

  def contextually_sensitive_method
    raise VerbotenMethodCallReachedKernel
  end
end

class RelaxedModeExamples < CordonUnitTest
  def self.good_class_context
    yield
  end
  def self.contextually_sensitive_class_method
    raise VerbotenMethodCallReachedKernel
  end
end

Cordon.blacklist Kernel, [:contextually_sensitive_method]
Cordon.add_to_dmz Kernel, [:good_context]
Cordon.add_to_dmz RelaxedModeExamples, [:good_class_context], :class_methods => true

class RelaxedModeExamples < CordonUnitTest
  def setup
    Cordon.relaxed_mode!
  end
  def teardown
    Cordon.strict_mode!
  end


  def test_bare_calls_to_blacklisted_methods_still_fails_by_default
    assert_raise(Cordon::Violation) do
      bad_context do
        send :contextually_sensitive_method
      end
    end
  end

  def test_bare_calls_to_blacklisted_methods_ok_for_methods_in_dmz
    assert_raise(VerbotenMethodCallReachedKernel) do
      good_context do
        send :contextually_sensitive_method
      end
    end
  end

  def test_dmz_works_even_when_contexts_are_nested
    assert_raise(VerbotenMethodCallReachedKernel) do
      good_context do
        good_context do
          send :contextually_sensitive_method
        end
        send :contextually_sensitive_method
      end
    end
  end

  def test_can_dmz_class_methods_too
    assert_raise(VerbotenMethodCallReachedKernel) do
      self.class.good_class_context do
        send :contextually_sensitive_class_method
      end
    end
  end
end
