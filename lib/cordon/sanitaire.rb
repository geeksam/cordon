module Cordon
  module Sanitaire
    def assert_that(predicate)
      ::Cordon::Whitelist.admit_one(predicate)
      return predicate
    end

  protected

    def __cordon__call_method__(subject, method, *args, &b)
      __cordon__check_permission__(subject, method, *args)
      um = ::Cordon::Blacklist.unbound_method(subject, method)
      um.bind(self).call(*args, &b)
    end

    def __cordon__check_permission__(subject, method, *args)
      unless ::Cordon::Whitelist.permitted?(self)
        message = '%s#%s(%s)' % [subject, method, args.map(&:inspect).join(', ')]
        raise ::Cordon::Violation, message
      end
    end
  end
end
