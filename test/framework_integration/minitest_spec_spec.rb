require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. helper]))
require 'minitest/autorun'

Cordon.embargo :minitest_spec

describe "MiniTest::Spec integration" do
  it 'works just fine if you adhere to the rules' do
    assert_that(42).must_equal 42
  end

  it 'explodes if you use standard^H^H evil MiniTest::Spec idiom' do
    begin
      42.must_equal 6*9
      flunk "This line should not be executed"
    rescue Cordon::Violation
      # all is well; carry on
    end
  end
end
