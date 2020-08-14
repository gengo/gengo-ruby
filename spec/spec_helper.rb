require 'rubygems'
require 'bundler/setup'
require 'webmock/rspec'

require 'gengo' # and any other gems you need

RSpec.configure do |config|
  # some (optional) config here
end

WebMock.allow_net_connect!
