package "ruby"
package "rubygems"

packagecloud_repo "computology/packagecloud-cookbook-test-public" do
  type "gem"
end

gem_package "jakedotrb"
