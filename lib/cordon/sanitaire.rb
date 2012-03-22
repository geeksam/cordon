module Cordon
  module Sanitaire

    def __cordon__assertion_wrapper__(predicate)
      Whitelist.admit_one(predicate)
      return predicate
    end

    def self.wrap_assertions_with(custom_method_name)
      alias_method custom_method_name, :__cordon__assertion_wrapper__
    end
    wrap_assertions_with :assert_that

  protected

    def __cordon__call_method__(subject, method, *args, &b)
      case
      when DMZ.includes?(subject, method)
        DMZ.invoke_method(self, subject, method, *args, &b)

      when Watchlist.includes?(subject, method)
        Watchlist.invoke_method(self, subject, method, *args, &b)

      when DMZ.occupied? || Whitelist.admits?(self)
        Blacklist.invoke_method(self, subject, method, *args, &b)

      else
        raise ::Cordon::Violation.from_invocation(subject, method, args)
      end
    end
  end
end
