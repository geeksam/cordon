require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. helper]))
require 'rspec'

Cordon.embargo :rspec

describe "RSpec integration" do
  it 'works just fine if you adhere to the rules' do
    assert_that(42).should == 42
  end

  it 'explodes if you use standard^H^H evil RSpec idiom' do
    begin
      42.should == 6*9
      raise "This line should not be executed"
    rescue Cordon::Violation
      # all is well; carry on
    end
  end
end
