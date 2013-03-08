=begin

  This is a spec that tests calls to account

=end

require 'spec_helper'
require 'gengo'

describe Gengo do

  before(:all) do

    @gengo_client = Gengo::API.new({
          :public_key => ENV['GENGO_PUBKEY'],
          :private_key => ENV['GENGO_PRIVKEY'],
          :debug => ENV['DEBUG'] == 'true',
          :sandbox => true
    })

  end

  describe "deleteTranslationOrder response" do
    it "should cancel all available jobs in an order" do
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

      sleep 10
      resp = @gengo_client.getTranslationOrderJobs({:order_id => $order_id})
      $count = resp['response']['order']['jobs_available'].length
      $count.to_i.should be > 0

      resp = @gengo_client.deleteTranslationOrder({:id => $order_id})
      resp['opstat'].should eq('ok')
      resp = @gengo_client.getTranslationOrderJobs({:order_id => $order_id})

      $count = resp['response']['order']['jobs_available'].length
      $count.to_i.should == 0
    end
  end
end