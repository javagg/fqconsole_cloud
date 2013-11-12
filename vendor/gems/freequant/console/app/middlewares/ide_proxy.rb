require 'rack/ws_proxy'

#class IdeProxy < ::Rack::WsProxy
#  def call(env)
#    EditingController.action(:show).call(env)
#    super(env)
#  end
#
#  def rewrite_env(env)
#    request = Rack::Request.new(env)
#    controller = env["action_controller.instance"]
#    app = controller.instance_variable_get(:@application)
#    user = controller.instance_variable_get(:@user)
#    login = user.as.login
#    password = user.as.password
#    remote_url = app.app_url
#    # TODO: Get prefix a batter way
#    prefix = "/application/#{app.id}-#{app.name}/editing/"
#    uri = translate(request.fullpath, "#{prefix}(.*)", "#{remote_url}$1")
#    uri.port = 8200
#    env["HTTP_HOST"] = "#{uri.host}:#{uri.port}"
#
#    # SCRIPT_NAME, REQUEST_URI, REQUEST_PATH have to be set for this proxy
#    # working with c9 sever.
#    env["PATH_INFO"] = uri.path
#    env["SCRIPT_NAME"] = ""
#    env["REQUEST_URI"] =  uri.request_uri
#    #puts uri
#    super(env)
#  end
#
#  # Rack::Chunked is used by default to handle chunk encoding
#  # For this to work with cloud9, we have to delete this header field.
#  def rewrite_response(triplet)
#    _, headers, _ = triplet
#    headers.delete('Transfer-Encoding')
#    super(triplet)
#  end
#
#  protected
#
#  def translate(path, from, to)
#    from_regexp= from.kind_of?(Regexp) ? from : /^#{from.to_s}/
#    url = to.clone
#    if url =~ /\$\d/
#      m = path.match(from_regexp)
#      m.to_a.each_with_index { |m, i| url.gsub!("$#{i.to_s}", m) }
#      URI(url)
#    else
#      URI.join(url, path)
#    end
#  end
#end

class IdeProxy < ::Rack::WsProxy
  #def rewrite_env(env)
  #  env["HTTP_HOST"] = "localhost:9292"
  #  #env["HTTP_HOST"] = "127.0.252.1:3131"
  #  env
  #end

  def rewrite_env(env)
    request = Rack::Request.new(env)
    #  remote_url = "http://strategy-saw.example.com:8200/"
    remote_url = "http://127.0.252.1:3131/"
    #
    #prefix = '/application/525b72766892df3031000042-strategy/editing/'
    prefix = '/ide/'
    uri = translate(request.fullpath, "#{prefix}(.*)", "#{remote_url}$1")
    #  uri.port = 3131
    env["HTTP_HOST"] = "#{uri.host}:#{uri.port}"

    # SCRIPT_NAME, REQUEST_URI, REQUEST_PATH have to be set for this proxy
    # working with c9 sever.
    env["PATH_INFO"] = uri.path
    env["SCRIPT_NAME"] = ""
    env["REQUEST_URI"] =  uri.request_uri
    #env["REQUEST_PATH"] =  uri.request_uri

    #request = Rack::Request.new(env)
    #puts request.fullpath
    #puts request.script_name
    #puts request.path_info
    #puts uri
    super(env)
  end

  # Rack::Chunked is used by default to handle chunk encoding
  # For this to work with cloud9, we have to delete this header field.
  def rewrite_response(triplet)
    _, headers, _ = triplet
    headers.delete('Transfer-Encoding')
    triplet
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

# We have to use thin, others don't work!
Faye::WebSocket.load_adapter("thin")