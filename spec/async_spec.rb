require "#{File.dirname(__FILE__)}/../lib/rack/promises"
require "#{File.dirname(__FILE__)}/../lib/rack/promises/no_promise_call_error"

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

  it "should raise an exception if call is called and pcall is not defined" do
    instance = SomeRackClass.new
    -> {
      instance.call({})
    }.should raise_error NoPromiseCallError
  end
end