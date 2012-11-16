#!/usr/bin/env ruby

require 'gengo'

@gengo_client = Gengo::API.new({
    :public_key => 'your_public_key',
    :private_key => 'your_private_key',
    :sandbox => false,
    :api_version => '2'
})

#build up individual jobs and the jobs hash for a non-homogeneous group of jobs (non-grouped)

@job_1_hash = {
    :type => "text",
    :slug => "APIv2 slug",
    :body_src => "word one",
    :lc_src => "en",
    :lc_tgt => "fr-ca",
    :tier => "standard",
    :comment => "this is a comment",
    :force => true
}

@job_2_hash = {
    :type => "text",
    :slug => "APIv2 slug",
    :body_src => "word two",
    :lc_src => "en",
    :lc_tgt => "ja",
    :tier => "standard",
    :comment => "this is a comment",
    :force => true
}

@job_3_hash = {
    :type => "text",
    :slug => "APIv2 slug",
    :body_src => "word two",
    :lc_src => "en",
    :lc_tgt => "ja",
    :tier => "standard",
    :comment => "this is a comment",
    :force => true
}

@jobs_hash = {
:jobs => {
:job_1 => @job_1_hash,
:job_2 => @job_2_hash,
:job_3 => @job_3_hash
}
}

resp = @gengo_client.postTranslationJobs(@jobs_hash)

useful_response_body = resp['response']
order_id = useful_response_body['order_id'].to_i

sleep(30)

puts @gengo_client.getTranslationOrderJobs({:order_id => order_id})
