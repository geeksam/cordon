module Cordon
  module Sanitaire
  end
end

# Protect ALL the things!
class Object
  include Cordon::Sanitaire
end

module Cordon
  Violation = Class.new(Exception)
  Blacklist = Hash.new { |hash, key| hash[key] = Hash.new }
  ObjectsPermittedOneCallToAnyBlacklistedMethod = []

  module Sanitaire
    def assert_that(predicate)
      Cordon.admit_one(predicate)
      return predicate
    end

    def __cordon__call_method__(subject, method, *args, &b)
      __cordon__check_permission__(subject, method, *args)
      unbound_method = Blacklist[subject][method]
      unbound_method.bind(self).call(*args, &b)
    end

    def __cordon__check_permission__(subject, method, *args)
      unless Cordon.permitted?(self)
        message = '%s#%s(%s)' % [subject, method, args.map(&:inspect).join(', ')]
        raise ::Cordon::Violation, message
      end
    end
  end

  class << self
    def embargo(framework)
      case framework
      when :rspec
        blacklist Kernel, [:should, :should_not]
      else
        raise "I don't know how to embargo #{framework}!"
      end
    end

    # Declare specific methods as off-limits
    def blacklist(subject, methods)
      methods.each do |method|
        method = method.to_sym
        next unless Blacklist[subject][method].nil?  # be idempotent

        # Unbind the original method, and replace it with a wrapper that
        # checks for permission before binding and calling the original
        return unless unbind_method(subject, method)
        replace_method_with_permissions_checking_wrapper(subject, method)
      end
    end

    def admit_one(object)
      ObjectsPermittedOneCallToAnyBlacklistedMethod << object
    end

    def permitted?(object)
      !! ObjectsPermittedOneCallToAnyBlacklistedMethod.delete(object)
    end

  protected

    def unbind_method(subject, method)
      Blacklist[subject][method] = subject.instance_method(method)
    end

    def replace_method_with_permissions_checking_wrapper(subject, method)
      __cordon__receiver__ = subject  # use a name unlikely to collide in the object's own binding
      subject.instance_eval do
        define_method(method) do |*args, &b|
          __cordon__call_method__(__cordon__receiver__, method, *args, &b)
        end
      end
    end
  end
end
