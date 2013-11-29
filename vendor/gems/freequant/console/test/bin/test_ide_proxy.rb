$:.unshift File.expand_path("../../../lib", __FILE__)

require 'rack/ws_proxy'

class IdeProxy < Rack::WsProxy
  def rewrite_env(env)
    env["HTTP_HOST"] = "localhost:9292"
    #env["HTTP_HOST"] = "127.0.252.1:3131"
    env
  end

  def rewrite_env(env)
    request = Rack::Request.new(env)
  #  remote_url = "http://strategy-saw.example.com:8200/"
    remote_url = "http://127.0.252.1:3131/"
  #
  #  prefix = '/application/525b72766892df3031000042-strategy/editing/'
  #  prefix = '/ide/'
    prefix = '/'
    uri = translate(request.fullpath, "#{prefix}(.*)", "#{remote_url}$1")
  #  uri.port = 3131
    env["HTTP_HOST"] = "#{uri.host}:#{uri.port}"
    env["PATH_INFO"] = uri.request_uri
    env["REQUEST_URI"] =  uri.request_uri
  #  puts "www:"+ uri.to_s
    env
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
end

Faye::WebSocket.load_adapter("thin")

# Didn't work, Because Rack::Lint is in the way
#run IdeProxy.new

EM.run {
  app = Rack::Builder.app do
    #use Rack::Lock
    use Rack::Chunked
    use Rack::ContentLength
    use Rack::ShowExceptions
    use Rack::Static
    use Rack::ConditionalGet
    use Rack::ETag
    use Rack::Runtime
    use Rack::MethodOverride

    run IdeProxy.new
  end
  thin = Rack::Handler.get('thin')
  thin.run(app, :Port => 8100)
}