require 'rack'
require 'rack-proxy'
require 'faye/websocket' # Hack for version 0.4.7

module Faye
  class WebSocket
    def initialize(env, supported_protos = nil, options = {})
      @env     = env
      @env     = env
      @stream  = Stream.new(self)
      @ping    = options[:ping]
      @ping_id = 0

      @url = WebSocket.determine_url(@env)
      @ready_state = CONNECTING
      @buffered_amount = 0

      @parser = WebSocket.parser(@env).new(self, :protocols => supported_protos)

      @send_buffer = []
      #EventMachine.next_tick { open }

      @callback = @env['async.callback']
      @callback.call([101, {}, @stream])
      @stream.write(@parser.handshake_response)

      @ready_state = OPEN if @parser.open?

      if @ping
        @ping_timer = EventMachine.add_periodic_timer(@ping) do
          @ping_id += 1
          ping(@ping_id.to_s)
        end
      end
    end

    # Make it public
    def open
      return if @parser and not @parser.open?
      @ready_state = OPEN

      buffer = @send_buffer || []
      while message = buffer.shift
        send(*message)
      end

      event = Event.new('open')
      event.init_event('open', false, false)
      dispatch_event(event)
    end
  end
end

module Rack
  class WsProxy < ::Rack::Proxy
    def handle_websocket(env)
      # Don't open until remote is ready
      ws = Faye::WebSocket.new(env, ['irc', 'xmpp'], :ping => 5)
      req = Rack::Request.new(rewrite_env(env))
      scheme = req.scheme == "http" ? "ws" : "wss"
      uri = "#{scheme}://#{req.host}:#{req.port}#{req.fullpath}"
      ws_remote = Faye::WebSocket::Client.new(uri)

      ws_remote.onopen = lambda do |event|
        ws.onopen = lambda do |event|
        end

        ws.onmessage = lambda do |event|
          ws_remote.send(event.data) if ws_remote
        end

        ws.onclose = lambda do |event|
          ws = nil
          ws_remote.close if ws_remote
        end

        EventMachine.next_tick { ws.open }
      end

      ws_remote.onmessage = lambda do |event|
        ws.send(event.data) if ws
      end

      ws_remote.onclose = lambda do |event|
        ws_remote = nil
        ws.close if ws
      end

      ws.rack_response
    end

    def call(env)
      if Faye::WebSocket.websocket?(env)
        handle_websocket(env)
      else
        super(env)
      end
    end
  end
end
