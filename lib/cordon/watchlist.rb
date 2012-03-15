require File.join(File.dirname(__FILE__), 'method_list')

module Cordon
  module Watchlist
    extend MethodList

    class << self
      def invoke_method(instance, subject, method, *args, &b)
        record_incursion(subject, method, args)
        super
      end

      def incursions
        @incursions ||= []
      end

      def incursion_report
        report = <<-EOF.strip
=======================
Cordon Incursion Report
=======================
        EOF
        n = incursions.length
        max_width = n.to_s.length

        incursions_by_method = Hash.new { |hash, key| hash[key] = [] }
        incursions.each do |incursion|
          incursions_by_method[incursion.method_descriptor] << incursion
        end

        incursions_by_method.to_a.sort.each do |method_descriptor, incursions|
          report << "\n\n#{method_descriptor}\n#{'-' * method_descriptor.length}"
          incursions.each do |incursion|
            report << "\n" + incursion.backtrace.first.to_s
          end
        end
        report << "\n"
        report
      end

    protected

      def record_incursion(subject, method, args)
        raise Cordon::Violation.from_invocation(subject, method, args)
      rescue Cordon::Violation => e
        incursions << e
      end
    end
  end
end
