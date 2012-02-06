module Cordon
  module Sanitaire
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
      false
    end

    def assert_that(predicate)
      ::Cordon::AssertionProxy.new(predicate)
    end
  end
end
