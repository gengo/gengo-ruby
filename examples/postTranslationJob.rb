# encoding: UTF-8
require 'gengo'

# Post a single job over to Gengo and print out the
# response JSON.

gengo = Gengo::API.new({
	:public_key => 'your_public_key',
	:private_key => 'your_private_key',
	:sandbox => true,
})

puts gengo.postTranslationJob({
	:job => {
		:type => "text",
		:slug => "Hallo",
		:body_src => "Hallo zusammen",
		:lc_src => "de",
		:lc_tgt => "en",
		:tier => "standard"
	}
})
