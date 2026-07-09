# frozen_string_literal: true

name 'packagecloud'

run_list 'test::default'

named_run_list :default, 'test::default'

cookbook 'packagecloud', path: '.'
cookbook 'test', path: 'test/cookbooks/test'
