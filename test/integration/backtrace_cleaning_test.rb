require File.join(File.dirname(__FILE__), 'integration_test_helper')

module Kernel
  def verboten_method_for_backtrace
    raise VerbotenMethodCallReachedKernel
  end
end

Cordon.blacklist Kernel, [:verboten_method_for_backtrace]

# Cordon will remove its own method calls from the backtrace; hopefully this will reduce confusion somewhat
class BacktraceCleaningUnitTest < CordonUnitTest
  def test_cordon_lines_are_removed_from_violation_backtrace
    foo.verboten_method_for_backtrace
  rescue Cordon::Violation => e
    failure_message = "cordon.rb appears in first line of backtrace:\n"
    failure_message << (e.backtrace[0..3] + ['(rest of backtrace omitted)']).map { |e| '  ' + e }.join("\n")
    refute e.backtrace.first.include?('cordon.rb:'), failure_message
  end

  def test_custom_cleaning
    Cordon.filter_violation_backtrace { |backtrace|
      project_root = File.expand_path(File.join(File.dirname(__FILE__), *%w[.. ..]))
      in_project = Regexp.new(project_root)
      backtrace.select { |line| line =~ in_project }
    }

    foo.verboten_method_for_backtrace

  rescue Cordon::Violation => e
    refute e.backtrace.any? { |line| line =~ /\/unit\.rb:/ }, "Custom backtrace filter did not work"

  ensure
    Cordon.dont_filter_violation_backtrace!
  end
end
