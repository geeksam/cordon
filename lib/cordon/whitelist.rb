module Cordon
  module Whitelist
    TheList = []

    def self.admit_one(object)
      TheList << object
    end

    def self.check_permissions(instance, subject, method, *args)
      allowed = !! TheList.delete(instance)
      return if allowed
      message = '%s#%s(%s)' % [subject, method, args.map(&:inspect).join(', ')]
      raise ::Cordon::Violation, message
    end
  end
end
