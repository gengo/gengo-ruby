=begin

  This is a spec that tests calls to account

=end

require 'spec_helper'
require 'gengo'

describe Gengo do

#  @created_job_id = nil

  before(:all) do

    @gengo_client = Gengo::API.new({
          :public_key => ENV['GENGO_PUBKEY'],
          :private_key => ENV['GENGO_PRIVKEY'],
          :api_version => '2',
          :debug => ENV['DEBUG'] == 'true',
          :sandbox => true
    })

  end

  describe "postTranslationJobs response" do
    it "should have opstat OK and have order_id in response" do
      resp = @gengo_client.postTranslationJobs({
        :jobs => {
          :job_1 => {
            :type => "text",
            :slug => "Hello",
            :body_src => "hello, world",
            :lc_src => "en",
            :lc_tgt => "ja",
            :tier => "standard",
            :force => 1
          }
        }
      })
      resp.should be_an_instance_of(Hash)
      resp['opstat'].should eq('ok')
      response_body = resp['response']
      $order_id = response_body['order_id']
      $order_id.should be_an_instance_of(String)
      $order_id.to_i.should be > 0
    end
  end

  describe "getTranslationOrderJobs response" do
    it "should have opstat OK and jobs_available" do
      resp = @gengo_client.getTranslationOrderJobs({:order_id => $order_id})
      resp.should be_an_instance_of(Hash)
      resp['opstat'].should eq('ok')
      response_body = resp['response']
      $created_job_id = response_body['order']['jobs_available'][0]
      $created_job_id.should be_an_instance_of(String)
      $created_job_id.to_i.should be > 0
    end
  end

  describe "getTranslationJob reponse" do
    it "should have opstat OK and correct body_src" do
      resp = @gengo_client.getTranslationJob({:id => $created_job_id})
      response_body = resp['response']
      body_src = response_body['job']['body_src']
      body_src.should eq('hello, world')
    end
  end

  describe "postTranslationJobComment response" do
    it "should have opstat OK" do
      resp = @gengo_client.postTranslationJobComment({:id => $created_job_id,
                                                      :body => "Test comment"})
      resp.should be_an_instance_of(Hash)
      resp['opstat'].should eq('ok')
    end
  end

  describe "getTranslationJobComments response" do
    it "should have opstat OK and correct thread" do
      resp = @gengo_client.getTranslationJobComments({:id => $created_job_id})
      response_body = resp['response']
      response_body['thread'][0]['body']
    end
  end
end
