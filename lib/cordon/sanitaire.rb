module Cordon
  module Sanitaire

    def __cordon__assertion_wrapper__(predicate)
      ::Cordon::Whitelist.admit_one(predicate)
      return predicate
    end

    def self.wrap_assertions_with(custom_method_name)
      alias_method custom_method_name, :__cordon__assertion_wrapper__
    end
    wrap_assertions_with :assert_that

  protected

    def __cordon__call_method__(subject, method, *args, &b)
      case
      when Watchlist.includes?(subject, method)
        ::Cordon::Watchlist.invoke_method(self, subject, method, *args, &b)
      when Whitelist.admits?(self)
        ::Cordon::Blacklist.invoke_method(self, subject, method, *args, &b)
      else
        message = '%s#%s(%s)' % [subject, method, args.map(&:inspect).join(', ')]
        raise ::Cordon::Violation, message
      end
    end
  end
end
