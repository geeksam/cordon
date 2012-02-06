module Cordon
  # Your basic Decorator.
  # Implemented by hand so that it's a subclass of Object (SimpleDelegator uses BasicObject in Ruby 1.9).
  # and therefore uses the intercepting method definitions in 
  class AssertionProxy
    def initialize(delegate)
      @delegate = delegate
    end
    
    def method_missing(method, *args, &block)
      @delegate.send(method, *args, &block)
    end

    def __cordon__expectations_allowed__
      true
    end
  end
end
