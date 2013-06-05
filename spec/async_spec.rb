require "#{File.dirname(__FILE__)}/../lib/rack/promises"

describe Rack::Promises do
  before(:each) do
    Object.send(:remove_const, :SomeRackClass) if Object.constants.include?(:SomeRackClass)
    class SomeRackClass
      include Rack::Promises
    end
  end

  it "should respond to call" do
    instance = SomeRackClass.new
    instance.should respond_to(:call)
  end
end