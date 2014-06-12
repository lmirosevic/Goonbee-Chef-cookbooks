yum_repository 'fengshuo' do
  description 'fengshuo'
  baseurl 'http://download.opensuse.org/repositories/home:/fengshuo:/zeromq/CentOS_CentOS-6/home:fengshuo:zeromq.repo'
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
