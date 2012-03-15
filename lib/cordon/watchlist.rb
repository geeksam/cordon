require File.join(File.dirname(__FILE__), 'method_list')

module Cordon
  module Watchlist
    extend MethodList

    class << self
      def invoke_method(instance, subject, method, *args, &b)
        record_incursion
        super
      end

      def incursions
        @incursions ||= []
      end

    protected

      def record_incursion
        raise Cordon::Violation
      rescue Cordon::Violation => e
        incursions << e
      end
    end
  end
end
