require 'rack'
require 'rack-proxy'
require 'faye/websocket'

module Rack
  class SubdomainTranslator
    def initialize(options={})
      @subdomain = options[:subdomain]
      @target = options[:target]
    end

    def translate(path, from, to)
      from_regexp= from.kind_of?(Regexp) ? from : /^#{from.to_s}/
      url = to.clone
      if url =~ /\$\d/
        if m = path.match(from_regexp)
          m.to_a.each_with_index { |m, i| url.gsub!("$#{i.to_s}", m) }
          URI(url)
        else
          URI.join(url, path)
        end
      end
    end

    def call(env)
      request = ::Rack::Request.new(env)
      #@target = 'http://www.sohu.com'
      uri = translate(request.fullpath, "#{@subdomain}(.*)", "#{@target}$1")
      env["HTTP_HOST"] = "#{uri.host}:#{uri.port}"

      # SCRIPT_NAME, REQUEST_URI, REQUEST_PATH have to be set for this proxy
      # working with c9 sever.
      env["PATH_INFO"] = uri.path == "" ? "/" : uri.path
      env["SCRIPT_NAME"] = ""
      env["REQUEST_URI"] =  uri.request_uri == "" ? "/" : uri.request_uri
      env
    end
  end

  class WsProxy < ::Rack::Proxy
    @@debug = false

    def self.debug=(enabled)
      @@debug = enabled
    end

    def chunked?(header)
      return false unless header['Transfer-Encoding']
      field = header['Transfer-Encoding']
      #(/(?:\A|[^\-\w])chunked(?![\-\w])/i =~ field) ? true : false
      (field === 'chunked') ? true : false
    end

    # Rack::Chunked is used by default to handle chunk encoding
    # For this to work with cloud9, we have to delete this header field.
    # Currently, it can't handle chunked
    def rewrite_response(triplet)
      _, headers, _ = triplet
      headers.delete('Transfer-Encoding') if chunked? headers
      headers.delete('Transfer-Encoding')
      triplet
    end

    def handle_websocket(env)
      # Open remote first
      req = Rack::Request.new(rewrite_env(env))
      scheme = req.scheme == "http" ? "ws" : "wss"
      uri = "#{scheme}://#{req.host}:#{req.port}#{req.fullpath}"

      ws_remote = Faye::WebSocket::Client.new(uri)

      ws_remote.onerror = lambda do |event|
        puts "remote error: #{event}" if @@debug
      end

      ws_remote.onopen = lambda do |event|
        puts "remote open" if @@debug
        ws = Faye::WebSocket.new(env, :ping => 5)
        ws.onopen = lambda do |event|
          puts "client open" if @@debug
        end

        ws.onerror = lambda do |event|
          puts "client error: #{event}" if @@debug
        end

        ws.onmessage = lambda do |event|
          puts "received from client, and send forward to remote" if @@debug
          ws_remote.send(event.data) if ws_remote
        end

        ws.onclose = lambda do |event|
          puts "client closed, then try to close remote" if @@debug
          ws = nil
          ws_remote.close if ws_remote
        end

        ws_remote.onmessage = lambda do |event|
          puts "received from remote, and send back to client" if @@debug
          ws.send(event.data) if ws
        end

        ws_remote.onclose = lambda do |event|
          puts "remote closed, then try to close remote" if @@debug

          ws_remote = nil
          ws.close if ws
        end
      end
      [ -1, {}, [] ]
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

