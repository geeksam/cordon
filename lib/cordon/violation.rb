module Cordon
  class Violation < Exception
    def backtrace
      bt = super
      bt.shift while bt && bt.first =~ /cordon\.rb\:\d+\:in/
      bt
    end
  end
end
