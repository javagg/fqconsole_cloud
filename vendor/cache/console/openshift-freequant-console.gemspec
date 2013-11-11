$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  spec_file = IO.read(File.expand_path("../rubygem-#{File.basename(__FILE__, '.gemspec')}.spec", __FILE__))

  s.name = 'openshift-freequant-console'
  s.version = spec_file.match(/^Version:\s*(.*?)$/mi)[1].chomp 

  s.summary = %q{OpenShift Freequant Management Console}
  s.description = %q{The OpenShift Freequant console is a Rails engine that provides an easy-to-use interface for managing OpenShift Freequant applications.}
  s.authors = ["Alex Lee"]
  s.email = ['lu.lee05@gmail.com']
  s.homepage = 'https://github.com/openshift/origin-server/tree/master/console'

  s.files = Dir['Gemfile', 'LICENSE', 'COPYRIGHT', 'README.md', 'Rakefile', 'app/**/*', 'config/**/*', 'lib/**/*', 'public/**/*', 'vendor/**/*', 'conf/**/*']
  s.test_files = Dir['test/**/*']

  # Console gem dependencies are explicitly specific since they must
  # match gems available in Fedora.  This may be relaxed at a future 
  # date.
  s.add_dependency 'openshift-origin-console'
  s.add_dependency 'devise', "2.2.7"
  s.add_dependency 'omniauth', '1.1.4'
  s.add_dependency 'omniauth-oauth', '1.0.1'
  s.add_dependency 'omniauth-oauth2', '1.1.1'
end
