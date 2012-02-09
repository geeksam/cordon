require File.join(File.dirname(__FILE__), *%w[.. helper])
require 'rspec'

Cordon.embargo :rspec

describe "RSpec integration" do
  it 'works just fine if you adhere to the rules' do
    assert_that(42).should == 42
  end

  it 'explodes if you use standard^H^H evil RSpec idiom' do
    naughty = lambda { 42.should == 6*9 }
    assert_that(naughty).should raise_error(Cordon::ExpectationIncursion)
  end
end
