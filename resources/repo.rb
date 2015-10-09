actions :add
default_action :add

attribute :repository,      :kind_of => String, :name_attribute => true
attribute :master_token,    :kind_of => String
attribute :force_os,        :kind_of => String
attribute :force_dist,      :kind_of => String
attribute :type,            :kind_of => String, :equal_to => ['deb', 'rpm', 'gem'], :default => node['packagecloud']['default_type']
attribute :base_url,        :kind_of => String, :default => "https://packagecloud.io"
attribute :gpg_key_url,     :kind_of => String, :default => node['packagecloud']['gpg_key_url']
attribute :gpg_key,         :kind_of => String
attribute :priority,        :kind_of => [Fixnum, TrueClass, FalseClass], :default => false
attribute :metadata_expire, :kind_of => String, :regex => [/^\d+[d|h|m]?$/], :default => nil
