require 'rubygems'
require 'faye/websocket'
require 'eventmachine'

port   = ARGV[0] || 3000
secure = ARGV[1] == 'ssl'

EM.run {
  scheme = secure ? 'wss' : 'ws'
  url    = "#{scheme}://localhost:#{port}/ide/"
  url    = "#{scheme}://localhost:#{port}/application/525b72766892df3031000042-strategy/editing/"
  socket = Faye::WebSocket::Client.new(url)

  puts "Connecting to #{socket.url}"

  socket.onopen = lambda do |event|
    p [:open]
    socket.send("Hello, WebSocket!")
  end

  socket.onmessage = lambda do |event|
    p [:message, event.data]
    socket.close 1002, 'Going away'
  end

  socket.onclose = lambda do |event|
    p [:close, event.code, event.reason]
    EM.stop
  end
}

