# Require ALL the sources!
Dir.glob(File.join(File.dirname(__FILE__), 'cordon/*.rb')).each { |f| require f }


# Protect ALL the objects!
class Object
  include Cordon::Sanitaire
end


# Patch ALL the monkeys!
module Kernel
  # This bit of metaprogramming replaces a blacklisted method with a hook that calls back
  # into the #__cordon__call_method__ defined in Cordon::Sanitaire (and, therefore, mixed in to Object)
  def __cordon__wrap_method__(method)
    # Take advantage of the fact that the block passed to define_method is a closure,
    # so we can find the blacklisted method quickly.
    # Use a name unlikely to collide in the object's own binding.
    __cordon__receiver__ = self
    define_method(method) do |*args, &b|
      subject = __cordon__receiver__
      __cordon__call_method__(subject, method, *args, &b)
      #                       ^^^^^^^^^^^^^^^ TODO: address Data Clump code smell?
    end
  end
end


module Cordon
  # Declare specific methods as off-limits
  def self.blacklist(subject, methods)
    methods.each do |method|
      Blacklist.blacklist_method(subject, method.to_sym)
    end
  end

  # Shorthand for blacklisting the undesirable methods in specific frameworks
  def self.embargo(framework)
    case framework
    when :rspec
      blacklist Kernel, [:should, :should_not]
    when :minitest_spec
      must_and_wont = MiniTest::Expectations.instance_methods.map(&:to_s).select {|e| e =~ /^(must|wont)_/}
      blacklist MiniTest::Expectations, must_and_wont
    else
      raise "I don't know how to embargo #{framework}!"
    end
  end
end
