module Cordon
  module Whitelist
    TheList = []

    def self.admit_one(object)
      TheList << object
    end

    def self.admits?(instance)
      !! TheList.delete(instance)
    end
  end
end
