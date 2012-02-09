module Cordon
  ExpectationIncursion = Class.new(Exception)

  class << self
    def embargo(framework)
      case framework
      when :rspec
        refuse :should, :should_not
      when :minitest_spec
        return unless defined?(MiniTest::Expectations)
        refuse *(MiniTest::Expectations.instance_methods - Module.instance_methods).map(&:to_s).sort
      else
        raise "I don't know how to embargo #{framework}!"
      end
    end

    # Declare specific methods as off-limits
    def refuse(*methods)
      methods.flatten.each do |method|
        Sanitaire.refuse_method method
      end
    end

    # Remove Cordon's protection for specific methods
    def permit(*methods)
      methods.flatten.each do |method|
        Sanitaire.permit_method method
      end
    end

    # Plumbing method; use this to apply Cordon's protection to a specific module or class.
    def wrap_module(m)
      m.module_eval do
        include ::Cordon::Sanitaire
      end
    end
  end

  module Sanitaire
    Whitelist = []

    class << self
      def refuse_method(method)
        define_method(method) do |*args|
          return super(*args) if __cordon__expectations_allowed__
          raise ::Cordon::ExpectationIncursion
        end
      end

      def permit_method(method)
        undef_method method if instance_methods.include?(method)
      end
    end

    def __cordon__expectations_allowed__
      !!Whitelist.delete(self)
    end

    def assert_that(predicate)
      Whitelist << predicate
      predicate
    end
  end
end


# Protect ALL the things!
Cordon.wrap_module Object
