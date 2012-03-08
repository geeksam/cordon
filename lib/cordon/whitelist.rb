module Cordon
  module Whitelist
    TheList = []

    def self.admit_one(object)
      TheList << object
    end

    def self.permitted?(object)
      !! TheList.delete(object)
    end
  end
end
