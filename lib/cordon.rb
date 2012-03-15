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
    end
  end
end


module Cordon
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

  # Declare specific methods as off-limits so that invocations raise an exception
  def self.blacklist(subject, methods)
    Blacklist.wrap_methods(subject, methods)
  end

  # Declare specific methods as off-limits so that invocations are logged
  def self.watchlist(subject, methods)
    Watchlist.wrap_methods(subject, methods)
  end

  # Allow user-defined aliases of #assert_that
  def self.wrap_assertions_with(custom_method_name)
    Sanitaire.wrap_assertions_with(custom_method_name)
  end

  # Convenience accessor for reporting on watchlist incursions
  def self.incursions
    Watchlist.incursions
  end

  # Plain-text report of watchlist incursions
  def self.incursion_report
    Watchlist.incursion_report
  end

  # Allow custom filtering of backtraces on Cordon::Violation errors.
  # Pass this a block that takes a backtrace and returns a backtrace.
  # Multiple filters can be defined; all will be applied.
  def self.filter_violation_backtrace(&proc)
    Violation.add_custom_backtrace_filter(&proc)
  end

  # Reset custom filtering of backtraces.
  # (This is mostly here for ease of testing.)
  def self.dont_filter_violation_backtrace!
    Violation.clear_custom_backtrace_filters
  end
end
