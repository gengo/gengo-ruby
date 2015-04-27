=begin

  This is a spec that tests calls to account

=end

require 'spec_helper'
require 'gengo'
require 'client_context'

describe Gengo::API do
  include_context('client spec')

  describe "getAccountBalance " do
    it "should be successful" do
      lambda do
        @gengo_client.getAccountBalance
      end.should_not raise_error
    end
  end


  describe "getAccountBalance response hash" do
    it "should have opstat OK and response as hash" do
        resp = @gengo_client.getAccountBalance
        resp.should be_an_instance_of(Hash)
        resp['opstat'].should eq('ok')
        useful_response_body = resp['response']
        useful_response_body.should be_an_instance_of(Hash)
    end
  end


  describe "getAccountBalance useful response" do

    before(:each) do
      resp = @gengo_client.getAccountBalance
      @useful_response_body = resp['response']
    end

    it "should have a credits field as a string" do
      credits = @useful_response_body['credits']
      credits.should be_an_instance_of(String)
    end

    it "should have a currency field as a string" do
      currency = @useful_response_body['currency']
      currency.should be_an_instance_of(String)
    end

    it "should have a credits field convertable to non-zero float" do
      credits_string = @useful_response_body['credits']
      credits_string.to_f.should be > 0
    end

    it "should have a currency field as USD" do
      currency = @useful_response_body['currency']
      currency.should eq(@my_currency)
    end

  end


  describe "getAccountStats " do
    it "should be successful" do
      lambda do
        @gengo_client.getAccountStats
      end.should_not raise_error
    end
  end


  describe "getAccountStats response hash" do
    it "should have opstat OK and response as hash" do
        resp = @gengo_client.getAccountStats
        resp.should be_an_instance_of(Hash)
        resp['opstat'].should eq('ok')
        useful_response_body = resp['response']
        useful_response_body.should be_an_instance_of(Hash)
    end
  end

  describe "getAccountStats useful response" do

    before(:each) do
      resp = @gengo_client.getAccountStats
      @useful_response_body = resp['response']
    end

    it "should have user_since as an Integer greater than 0" do
      user_since = @useful_response_body['user_since']
      user_since.should be_kind_of(Integer)
      user_since.should be > 0
    end

    it "should have credits_spent as a String" do
      credits_spent = @useful_response_body['credits_spent']
      credits_spent.should be_an_instance_of(String)
    end

    it "should have a currency field as a string" do
      currency = @useful_response_body['currency']
      currency.should be_an_instance_of(String)
    end

    it "should have a currency field as USD" do
      currency = @useful_response_body['currency']
      currency.should eq(@my_currency)
    end

  end

end
