require 'rack'
require 'faye/websocket'

class IdeProxy
  def call(env)
    if Faye::WebSocket.websocket?(env)
      ws = Faye::WebSocket.new(env, ['irc', 'xmpp'], :ping => 5)
      p [:open, ws.url, ws.version, ws.protocol]

      ws.onmessage = lambda do |event|
        p event.data
        ws.send(event.data)
      end

      ws.onclose = lambda do |event|
        p [:close, event.code, event.reason]
        ws = nil
      end
      ws.rack_response
    else
      Rack::File.new(File.dirname(__FILE__)).call(env)
    end
  end
end

Faye::WebSocket.load_adapter('thin')

EM.run {
  thin = Rack::Handler.get('thin')
  thin.run(IdeProxy.new, :Port => 8200)
}


