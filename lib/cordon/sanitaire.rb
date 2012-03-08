module Cordon
  module Sanitaire
    def assert_that(predicate)
      ::Cordon.admit_one(predicate)
      return predicate
    end

  protected

    def __cordon__call_method__(subject, method, *args, &b)
      __cordon__check_permission__(subject, method, *args)
      unbound_method = Blacklist[subject][method]
      unbound_method.bind(self).call(*args, &b)
    end

    def __cordon__check_permission__(subject, method, *args)
      unless ::Cordon.permitted?(self)
        message = '%s#%s(%s)' % [subject, method, args.map(&:inspect).join(', ')]
        raise ::Cordon::Violation, message
      end
    end
  end
end
