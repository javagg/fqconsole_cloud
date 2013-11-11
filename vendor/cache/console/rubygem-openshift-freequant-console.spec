%if 0%{?fedora}%{?rhel} <= 6
    %global scl ruby193
    %global scl_prefix ruby193-
%endif
%{!?scl:%global pkg_name %{name}}
%{?scl:%scl_package rubygem-%{gem_name}}
%global gem_name openshift-freequant-console
%global rubyabi 1.9.1

Summary:       OpenShift Freequant Management Console
Name:          rubygem-%{gem_name}
Version:       0.0.1
Release:       1%{?dist}
Group:         Development/Languages
License:       ASL 2.0
URL:           https://openshift.redhat.com
Source0:       rubygem-%{gem_name}-%{version}.tar.gz
%if 0%{?fedora} >= 19
Requires:      ruby(release)
%else
Requires:      %{?scl:%scl_prefix}ruby(abi) >= %{rubyabi}
%endif
Requires:      %{?scl:%scl_prefix}rubygems
Requires:      %{?scl:%scl_prefix}rubygem(devise)
Requires:      %{?scl:%scl_prefix}rubygem(omniauth)
Requires:      %{?scl:%scl_prefix}rubygem(omniauth-oauth)
Requires:      %{?scl:%scl_prefix}rubygem(omniauth-oauth2)
Requires:      %{?scl:%scl_prefix}rubygem(omniauth-facebook)
Requires:      %{?scl:%scl_prefix}rubygem(omniauth-twitter)
Requires:      %{?scl:%scl_prefix}rubygem(omniauth-github)
Requires:      %{?scl:%scl_prefix}rubygem(omniauth-linkedin)
Requires:      %{?scl:%scl_prefix}rubygem(omniauth-google-oauth2)
Requires:      %{?scl:%scl_prefix}rubygem(thin)
Requires:      %{?scl:%scl_prefix}rubygem(puma)
Requires:      %{?scl:%scl_prefix}rubygem(rack-proxy)
Requires:      %{?scl:%scl_prefix}rubygem(faye-websocket)
Requires:      %{?scl:%scl_prefix}rubygem(bootstrap-sass-rails)
Requires:      %{?scl:%scl_prefix}rubygem(font-awesome-rails)
Requires:      rubygem(openshift-origin-console)

%if 0%{?fedora}%{?rhel} <= 6
BuildRequires: %{?scl:%scl_prefix}build
BuildRequires: scl-utils-build
%endif

BuildRequires: %{?scl:%scl_prefix}rubygem(bootstrap-sass-rails)
BuildRequires: %{?scl:%scl_prefix}rubygem(font-awesome-rails)
BuildRequires: %{?scl:%scl_prefix}rubygems-devel
%if 0%{?fedora} >= 19
BuildRequires: ruby(release)
%else
BuildRequires: %{?scl:%scl_prefix}ruby(abi) >= %{rubyabi}
%endif
BuildRequires: %{?scl:%scl_prefix}rubygems
BuildArch:     noarch
Provides:      rubygem(%{gem_name}) = %version

%description
This contains the OpenShift Freequant Management Console.

%package doc
Summary: OpenShift Freequant Management Console docs.

%description doc
OpenShift Freequant Management Console ri documentation 

%prep
%setup -q

%build
%{?scl:scl enable %scl - << \EOF}

set -e
mkdir -p .%{gem_dir}

%if 0%{?fedora}%{?rhel} <= 6
rm -f Gemfile.lock
bundle install --local

mkdir -p %{buildroot}%{_var}/log/freequant/console/
mkdir -m 770 %{buildroot}%{_var}/log/freequant/console/httpd/
touch %{buildroot}%{_var}/log/freequant/console/production.log
chmod 0666 %{buildroot}%{_var}/log/freequant/console/production.log

pushd test/rails_app/
CONSOLE_CONFIG_FILE=../../conf/console.conf.example \
  RAILS_ENV=production \
  RAILS_LOG_PATH=%{buildroot}%{_var}/log/freequant/console/production.log \
  RAILS_RELATIVE_URL_ROOT=/console bundle exec rake assets:precompile assets:public_pages

rm -rf tmp/cache/*
echo > %{buildroot}%{_var}/log/freequant/console/production.log
popd

find . -name .gitignore -delete
find . -name .gitkeep -delete

rm -rf %{buildroot}%{_var}/log/freequant/*

rm -f Gemfile.lock
%endif

# Create the gem as gem install only works on a gem file
gem build %{gem_name}.gemspec

gem install -V \
        --local \
        --install-dir ./%{gem_dir} \
        --bindir ./%{_bindir} \
        --force \
        %{gem_name}-%{version}.gem
%{?scl:EOF}

%install
mkdir -p %{buildroot}%{gem_dir}
cp -a ./%{gem_dir}/* %{buildroot}%{gem_dir}/

%files
%doc %{gem_instdir}/Gemfile
%doc %{gem_instdir}/LICENSE 
%doc %{gem_instdir}/README.md
%doc %{gem_instdir}/COPYRIGHT
%{gem_instdir}
%{gem_cache}
%{gem_spec}

%files doc
%{gem_dir}/doc/%{gem_name}-%{version}

%changelog
* Fri Aug 9 2013 Clayton Coleman <ccoleman@redhat.com> 0.0.1-1
- Initial commit

