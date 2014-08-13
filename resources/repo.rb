actions :add
default_action :add

attribute :repository,   :kind_of => String, :name_attribute => true
attribute :master_token, :kind_of => String
attribute :type,         :kind_of => String, :equal_to => ['deb', 'rpm', 'gem'], :default => node['packagecloud']['default_type']
