if platform_family?('debian')
  execute 'update apt' do
    command 'apt-get update'
  end
end

package "ruby1.9"
package "rubygems1.9"
package "libopenssl-ruby1.9"

execute "update-alternatives --install /usr/bin/ruby ruby /usr/bin/ruby1.9 400"
