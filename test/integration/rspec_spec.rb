require File.join(File.dirname(__FILE__), *%w[.. helper])
require 'rspec'

describe "RSpec integration" do
  it 'works just fine if you adhere to the rules' do
    assert_that(42).should == 42
  end
end
