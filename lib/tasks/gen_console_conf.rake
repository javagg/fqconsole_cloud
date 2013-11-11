require 'erb'

namespace :fqconsole do
  desc "Generate console.conf"
  task :config do
    template = File.join(File.dirname(__FILE__), '..', '..', 'conf', 'openshift', 'console.conf.erb')
    message = ERB.new(IO.read(template))
    outfile = File.new(File.join(File.dirname(__FILE__), '..', '..', 'etc', 'openshift', 'console.conf'), "w")
    outfile.puts message.result
  end
end
