require "em-promise"
require "eventmachine"
require "rack/test"
require "#{File.dirname(__FILE__)}/../lib/rack/promises/test/async_helper"
require_relative "rack_app"

include Rack::Promises::Methods

def app
  Tester.new
end

describe Rack::Promises::AsyncSession do
  it "should not interfere with normal gets" do
    get "/"
    last_response.should be_ok
  end

  it "should work with async requests" do
    pending
  end

  it "should handle exceptions in async requests" do
    pending
  end
end