repository 'home_fengshuo_zeromq' do
  description 'The latest stable of zeromq builds (CentOS_CentOS-6)'
  baseurl 'http://download.opensuse.org/repositories/home:/fengshuo:/zeromq/CentOS_CentOS-6/'
  gpgkey 'http://download.opensuse.org/repositories/home:/fengshuo:/zeromq/CentOS_CentOS-6/repodata/repomd.xml.key'
  action :create
end

yum_package 'zeromq' do
  action :install
  # flush_cache [:before]
end

yum_package 'zeromq-devel' do
  action :install
  # flush_cache [:before]
end
