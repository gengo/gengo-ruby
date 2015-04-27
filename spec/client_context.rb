require 'spec_helper'
require 'gengo'

RSpec.shared_context 'client spec' do
  before(:all) do
    pubkey, privkey = ENV['GENGO_PUBKEY'], ENV['GENGO_PRIVKEY']
    raise "Set GENGO_PUBKEY environment variables" if pubkey.nil? or pubkey.empty?
    raise "Set GENGO_PRIVKEY environment variables" if privkey.nil? or privkey.empty?

    @gengo_client = Gengo::API.new({
      :public_key => ENV['GENGO_PUBKEY'],
      :private_key => ENV['GENGO_PRIVKEY'],
      :debug => ENV['DEBUG'] == 'true',
      :sandbox => true
    })
    @my_currency = "USD"
  end
end
