module Cordon
  CordonViolation = Class.new(Exception)
  CordonedMethods = Hash.new { |hash, key| hash[key] = Hash.new }
  OneTimePasses = []

  module Sanitaire
    def assert_that(predicate)
      Cordon.admit_one(predicate)
      return predicate
    end

    def __cordon__call_method__(subject, method, *args)
      raise ::Cordon::CordonViolation unless Cordon.permitted?(self)
      unbound_method = CordonedMethods[subject][method]
      unbound_method.bind(self).call(*args)
    end
  end

  class << self
    def embargo(framework)
      case framework
      when :rspec
      when :minitest_spec
        return unless defined?(MiniTest::Expectations)
        refuse *(MiniTest::Expectations.instance_methods - Module.instance_methods).map(&:to_s).sort
        refuse Kernel, [:should, :should_not]
      else
        raise "I don't know how to embargo #{framework}!"
      end
    end

    # Declare specific methods as off-limits
    def refuse(subject, methods)
      methods.each do |method|
        next if CordonedMethods[subject][method]  # be idempotent

        # Unbind the original method, and replace it with a wrapper that
        # checks for permission before binding and calling the original
        return unless unbind_method(subject, method.to_sym)
        replace_method_with_permissions_checking_wrapper(subject, method.to_sym)
      end
    end

    def admit_one(object)
      OneTimePasses << object
    end

    def permitted?(object)
      !! OneTimePasses.delete(object)
    end

  protected

    def unbind_method(subject, method)
      CordonedMethods[subject][method] = subject.instance_method(method)
    end

    def replace_method_with_permissions_checking_wrapper(subject, method)
      __cordon__receiver__ = subject  # use a name unlikely to collide in the object's own binding
      subject.instance_eval do
        define_method(method) do |*args|
          __cordon__call_method__(__cordon__receiver__, method, *args)
        end
      end
    end
  end
end

# Protect ALL the things!
class Object
  include Cordon::Sanitaire
end
