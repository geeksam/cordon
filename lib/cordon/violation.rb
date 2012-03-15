module Cordon
  class Violation < Exception
    SelfRegex = /\/lib\/cordon.*\.rb\:\d+\:in/
    CustomFilterProcs = []

    def self.add_custom_backtrace_filter(&proc)
      CustomFilterProcs << proc
    end

    def self.clear_custom_backtrace_filters
      CustomFilterProcs.clear
    end

    def backtrace
      bt = super
      return if bt.nil?

      # Take anything in 'lib/cordon*.rb' off of the *top* of the backtrace so users don't get distracted by it
      bt.shift while bt.first =~ SelfRegex

      # Apply any other custom filters to the backtrace before returning it
      CustomFilterProcs.each do |filter|
        bt = filter.call(bt)
      end

      return bt
    end
  end
end
