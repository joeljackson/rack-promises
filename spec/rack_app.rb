class Tester
  def initalize
  end

  def call(env)
    if env["PATH_INFO"] == "/"
      [200, {}, "Hello World"]
    elsif env["PATH_INFO"] == "/promise"
      deferred = EM::Q.defer
      EM::Timer.new(0.1) do 
        deferred.resolve([200, {}, "Hello world"])
      end
      deferred.promise
    elsif env["PATH_INFO"] == "/promise_exception"
      deferred = EM::Q.defer
      EM::Timer.new(0.1) do 
        deferred.resolve([200, {}, "Hello world"])
      end
      deferred.promise.then do |result|
        raise Exception.new
      end
    end
  end
end