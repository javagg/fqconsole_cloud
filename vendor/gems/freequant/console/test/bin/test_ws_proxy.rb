$:.unshift File.expand_path("../../../lib", __FILE__)

# Use latency example in engine.io to test it
require 'rack/ws_proxy'

class IdeProxy < ::Rack::WsProxy
  def rewrite_env(env)
    env["HTTP_HOST"] = "localhost:3000"
    env
  end
end

Faye::WebSocket.load_adapter("thin")

# Didn't work, Because Rack::Lint is in the way
#run IdeProxy.new

EM.run {
  app = Rack::Builder.app do
    run IdeProxy.new
  end
  thin = Rack::Handler.get('thin')
  thin.run(app, :Port => 8400)
}