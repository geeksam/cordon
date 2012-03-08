module Cordon
  module Sanitaire
    def assert_that(predicate)
      ::Cordon::Whitelist.admit_one(predicate)
      return predicate
    end

  protected

    def __cordon__call_method__(subject, method, *args, &b)
      ::Cordon::Whitelist.check_permissions(self, subject, method, *args)
      ::Cordon::Blacklist.invoke_method(self, subject, method, *args, &b)
    end
  end
end
