module Cordon
  module Blacklist
    TheList = {}

    def self.blacklist_method(subject, method)
      return if unbound_method(subject, method)  # be idempotent

      # Unbind the original method, and replace it with a wrapper that
      # checks for permission before binding and calling the original
      unbind_method(subject, method)
      subject.__cordon__wrap_method__(method)
    end

    def self.invoke_method(instance, subject, method, *args, &b)
      um = unbound_method(subject, method)
      um.bind(instance).call(*args, &b)
    end

  protected

    def self.unbind_method(subject, method)
      um = subject.instance_method(method) # will raise NameError if the method doesn't exist
      TheList[[subject, method]] = um
    end

    def self.unbound_method(subject, method)
      TheList[[subject, method]]
    end
  end
end
