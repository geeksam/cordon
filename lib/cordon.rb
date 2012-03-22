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
    wrap_framework(framework, :blacklist)
  end

  # Shorthand for watchlisting the undesirable methods in specific frameworks
  # NOTE:  while this will record incursions, you'll have to call Cordon.incursion_report
  # yourself until I figure out how to make it print out at exit.
  def self.monitor(framework)
    wrap_framework(framework, :watchlist)
  end

  def self.mode
    @mode ||= :strict
  end
  def self.relaxed_mode!
    @mode = :relaxed
  end
  def self.strict_mode!
    @mode = :strict
  end


  # Declare specific methods as off-limits so that invocations raise an exception
  def self.blacklist(subject, methods)
    Blacklist.wrap_methods(subject, methods)
  end

  # Declare specific methods as off-limits so that invocations are logged
  def self.watchlist(subject, methods)
    Watchlist.wrap_methods(subject, methods)
  end

  def self.add_to_dmz(subject, methods, options = {})
    DMZ.wrap_methods(subject, methods, options)
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

protected

  def self.wrap_framework(framework, technique)
    raise "Don't know how to wrap framework with #{technique.inspect}!" unless [:blacklist, :watchlist].include?(technique)

    # Figure out which methods to wrap
    protected_list, dmz_list = [], []
    case framework
    when :rspec
      protected_list << [Kernel, [:should, :should_not]]
      dmz_list << [RSpec::Core::ExampleGroup, [:example, :it, :specify, :focused, :focus], :class_methods => true]
    when :minitest_spec
      must_and_wont = MiniTest::Expectations.instance_methods.map(&:to_s).select {|e| e =~ /^(must|wont)_/}
      protected_list << [MiniTest::Expectations, must_and_wont]
    else
      raise "I don't know how to embargo #{framework}!"
    end

    # Wrap them using the appropriate technique
    # (which should be either :blacklist or :watchlist)
    protected_list.each do |subject, methods|
      send technique, subject, methods
    end
    dmz_list.each do |subject, methods, options|
      add_to_dmz subject, methods, options || {}
    end
  end

end
