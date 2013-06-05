require "em-promise"
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
    expect(-> {
      instance.call({})
    }).to raise_error NoPromiseCallError
  end

  it "should return watever value it's given if the result is not a promise" do
    SomeRackClass.send(:define_method, :pcall) do |env|
      [200, {}, "Hello world"]
    end
    instance = SomeRackClass.new
    instance.call({}).should == [200, {}, "Hello world"]
  end
  
  it "should throw async if a promise is returned" do
    SomeRackClass.send(:define_method, :pcall) do |env|
      EventMachine::Q.defer.promise
    end
    instance = SomeRackClass.new
    expect( -> {
              instance.call({})
            }).to throw_symbol(:async)
  end

  it "should fulfill the promise with the rack async callback" do
    pending
  end
end