require "em-promise"
require "eventmachine"
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
    #This is kind of weird and barftastic. Not sure how to make it better?
    #When refactorme.com is done I'll find out there!! :-)
    some_value = 0
    Thread.new do
      EM.run
    end

    SomeRackClass.send(:define_method, :pcall) do |env|
      deferred = EM::Q.defer
      EM::Timer.new(0.1) do 
        deferred.resolve([200, {}, "Hello world"])
      end
      deferred.promise
    end

    instance = SomeRackClass.new
    catch(:async) do
      instance.call({'async.callback' => lambda { |result|
                        some_value = 1
                      }})
    end
    while some_value == 0
      sleep 0.1
    end
    some_value.should == 1
  end
end