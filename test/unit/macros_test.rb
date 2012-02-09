require File.join(File.dirname(__FILE__), 'unit_helper')

class CordonMacrosTest < Test::Unit::TestCase
  def setup
    Cordon.module_eval <<-RUBY
      module MiniTest
        module Expectations
          def must_equal; end
          def wont_equal; end
          def must_be_nil; end
          def wont_be_nil; end
        end
      end
    RUBY
  end

  def teardown
    Cordon::MiniTest.module_eval 'remove_const :Expectations'
    Cordon.module_eval           'remove_const :MiniTest'
  end


  def test_rspec_macro
    Cordon.expects(:refuse).with(:should, :should_not)
    Cordon.embargo :rspec
  end

  def test_minitest_spec_macro
    Cordon.expects(:refuse).with(*%w[must_equal wont_equal must_be_nil wont_be_nil].sort)
    Cordon.embargo :minitest_spec
  end
end
