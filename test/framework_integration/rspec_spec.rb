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

describe "RSpec in 'relaxed mode'" do
  subject { 42 }

  before(:all) do
    Cordon.relaxed_mode!
  end
  after(:all) do
    Cordon.strict_mode!
  end

  it "lets you get away with using #should and #should_not on the implicit receiver" do
    should == 42
    should_not == 6*9
  end

  it "lets you get away with using #should anywhere inside an #it block" do
    pending "some sort of around filter, maybe?"
  end
end
