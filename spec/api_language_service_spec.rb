=begin

  This is a spec that tests calls to account

=end

require 'spec_helper'
require 'gengo'
require 'client_context'

describe Gengo::API do
  include_context('client spec')

  describe "getServiceLanguagePairs " do
    it "should be successful" do
      lambda do
        @gengo_client.getServiceLanguagePairs
      end.should_not raise_error
    end
  end

  describe "getServiceLanguagePairs response" do
    it "should have opstat OK and response as array" do
      resp = @gengo_client.getServiceLanguagePairs
      resp.should be_an_instance_of(Hash)
      resp['opstat'].should eq('ok')
      response_body = resp['response']
      response_body.should be_an_instance_of(Array)
    end
  end

  describe "getServiceLanguages response" do
    it "should have opstat OK and response as list" do
      resp = @gengo_client.getServiceLanguages
      resp.should be_an_instance_of(Hash)
      resp['opstat'].should eq('ok')
      response_body = resp['response']
      response_body.should be_an_instance_of(Array)
    end
  end
end
