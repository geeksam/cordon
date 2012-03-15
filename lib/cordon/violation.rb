module Cordon
  class Violation < Exception
    SelfRegex = /\/lib\/cordon.*\.rb\:\d+\:in/

    def backtrace
      bt = super
      bt.shift while bt && bt.first =~ SelfRegex
      bt
    end
  end
end
