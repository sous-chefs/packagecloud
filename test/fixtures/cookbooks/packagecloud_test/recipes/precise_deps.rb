if platform_family?('debian')
  execute 'update apt' do
    command 'apt-get update'
  end
end

package "ruby"
package "rubygems"
