module Cordon
  module DMZ
    extend MethodList

    # Flag that *should* indicate whether the current call stack includes
    # a "safe" context from which to invoke cordoned methods
    def self.occupied?
      !!@occupied
    end

    # Flag management
    def self.enter!; @occupied = true;  end
    def self.leave!; @occupied = false; end

    # Set the DMZ flag 
    def self.invoke_method(instance, subject, method, *args, &b)
      DMZ.enter!
      super
    ensure
      DMZ.leave!
    end
  end
end
