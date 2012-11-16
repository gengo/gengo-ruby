# encoding: UTF-8
require 'gengo'

# Post multiple (grouped) jobs over to Gengo, and print
# their response.

gengo = Gengo::API.new({
	:public_key => 'your_public_key',
	:private_key => 'your_private_key',
	:sandbox => true,
})

puts gengo.postTranslationJobs({
	:jobs => {
		:job_1 => {
			:type => "text",
			:slug => "Hallo",
			:body_src => "Hallo zusammen",
			:lc_src => "de",
			:lc_tgt => "en",
			:tier => "standard"
		},
		:job_2 => {
			:type => "text",
			:slug => "Nice",
			:body_src => "Nice to meet you.",
			:lc_src => "en",
			:lc_tgt => "ja",
			:tier => "standard"
		}
	}
})
