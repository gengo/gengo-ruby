=begin

  This is a spec that tests calls to account

=end

require 'spec_helper'
require 'gengo'
require 'client_context'

describe Gengo::API do
  include_context 'client spec'

  describe "getTranslationOrderJobs" do
    it "should call redirected destination" do
      public_key = 'pubkeyfortests'
      private_key = 'privatekeyfortestuserthatcontainsonlyletters'

      query = {:api_key => public_key, :ts => Time.now.gmtime.to_i.to_s}

      endpoint = "translate/order/10"
      url_str = "https://api.gengo.dev/v2/" + endpoint

      options = "?api_sig=" + (OpenSSL::HMAC.hexdigest 'sha1', private_key, query[:ts])
      options << '&' + query.map { |k, v| "#{k}=#{CGI::escape(v)}" }.join('&')
      headers = {
        'Accept' => 'application/json',
        'User-Agent' => 'RSpec test',
      }

      stub_request(:get, url_str + options)
        .to_return(status: 302, headers: {'Location' => 'https://api.gengo.dev/', 'Content-Type' => 'text/html'})
      stub_request(:get, "https://api.gengo.dev/" + options)
        .to_return(body: 'contents', headers: {'Content-Type' => 'text/html' })
      
      expect(@gengo_client).to receive(:call_api).and_call_original.twice
      @gengo_client.call_api(url_str, headers, false, options)
    end
  end
end
