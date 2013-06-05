#Tanks to raggi and his magnificent async_sinatra gem for this.
class AsyncSession < Rack::MockSession
  class AsyncCloser
    def initialize
      @callbacks, @errbacks = [], []
    end
    def callback(&b)
      @callbacks << b
    end
    def errback(&b)
      @errbacks << b
    end
    def fail
      @errbacks.each { |cb| cb.call }
      @errbacks.clear
    end
    def succeed
      @callbacks.each { |cb| cb.call }
      @callbacks.clear
    end
  end

  def request(uri, env)
    @responded = false
    env['async.callback'] = lambda { |r| s,h,b = *r; handle_last_response(uri, env, s,h,b) }
    env['async.close'] = AsyncCloser.new
    catch(:async) { super }
    @last_response ||= Rack::MockResponse.new(-1, {}, [], env["rack.errors"].flush)
    until @responded || @last_response.status != -1
      #Since things are going on in the reactor just chill relax and max all cool. For now.
      sleep 0.1 #TODO, figure out how to get out of here if something in the Reactor thread exploded
    end
  end

  def handle_last_response(uri, env, status, headers, body)
    @last_response = Rack::MockResponse.new(status, headers, body, env["rack.errors"].flush)
    body.close if body.respond_to?(:close)

    cookie_jar.merge(last_response.headers["Set-Cookie"], uri)

    @after_request.each { |hook| hook.call }
    @responded = true
    @last_response
  end
end

module Methods
  include Rack::Test::Methods
  def build_rack_mock_session # XXX move me
    MatchMaker::Test::AsyncSession.new(app)
  end
end
