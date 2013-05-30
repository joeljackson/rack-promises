module Rack
  module Promises
    def call(env)
      raise NoPromiseCallError unless defined?(pcall)
      result = pcall(env)
      if result.is_a?(EventMachine::Q::Promise)
        result.then do |return_value|
          env['async.callback'].call(return_value)
        end
        throw :async
      end
      return result
    end
  end
end
