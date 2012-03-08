module Cordon
  module Blacklist
    TheList = Hash.new { |hash, key| hash[key] = Hash.new }

    def self.unbind_method(subject, method)
      TheList[subject][method] = subject.instance_method(method)
    end

    def self.unbound_method(subject, method)
      TheList[subject][method]
    end
  end
end
