require 'rack/ws_proxy'

class SubdomainIdeProxy < Rack::WsProxy
  def rewrite_env(env)
    request = Rack::Request.new(env)
    #controller = env["action_controller.instance"]
    #app = controller.instance_variable_get(:@application)
    #user = controller.instance_variable_get(:@user)
    #login = user.as.login
    #password = user.as.password
    #remote_url = app.app_url
    remote_url = "http://localhost:3131"

    # request.script_name is from the rails route
    # request.path_info is the part that is parsed by proxied server
    # request.fullpath is the url that users can see in the browser
    # fullpath = script_name + path_info + ? + query_string
    prefix =  request.script_name
    uri = translate(request.fullpath, "#{prefix}(.*)", "#{remote_url}$1")

    # We also need to set the right port, because the old one is
    # for the app itself, not for its ide.
    uri.port = ENV["FREEQUANT_IDE_PORT"].to_i || 8200

    # Finally, we got the right url
    env["HTTP_HOST"] = "#{uri.host}:#{uri.port}"
    env["PATH_INFO"] = request.path_info
    env["SCRIPT_NAME"] = ''
    env["REQUEST_URI"] =  uri.request_uri
    super(env)
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