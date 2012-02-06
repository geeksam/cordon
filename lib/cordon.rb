require 'cordon/assertion_proxy'
require 'cordon/sanitaire'

module Cordon
  ExpectationIncursion = Class.new(Exception)

  class << self
    # Declare specific methods as off-limits
    def refuse(*methods)
      methods.flatten.each do |method|
        ::Cordon::Sanitaire.refuse_method method
      end
    end

    # Remove Cordon's protection for specific methods
    def permit(*methods)
      methods.flatten.each do |method|
        ::Cordon::Sanitaire.permit_method method
      end
    end

    # Plumbing method; use this to apply Cordon's protection to a specific module or class.
    def wrap_module(m)
      m.module_eval do
        include ::Cordon::Sanitaire
      end
    end
  end
end


# Protect ALL the things!
Cordon.wrap_module Object
