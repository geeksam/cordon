module Cordon
  module Watchlist
    TheList = {}

    def self.watchlist_method(subject, method)
      return if unbound_method(subject, method)  # be idempotent

      # Unbind the original method, and replace it with a wrapper that
      # checks for permission before binding and calling the original
      unbind_method(subject, method)
      subject.__cordon__wrap_method__(method)
    end

    def self.invoke_method(instance, subject, method, *args, &b)
      begin
        raise Cordon::Violation
      rescue Cordon::Violation => e
        incursions << e
      end

      # TODO: make it so that the following lines can be replaced with "super"
      um = unbound_method(subject, method)
      um.bind(instance).call(*args, &b)
    end

    def self.incursions
      @incursions ||= []
    end

    def self.includes?(subject, method)
      TheList.has_key?([subject, method])
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
