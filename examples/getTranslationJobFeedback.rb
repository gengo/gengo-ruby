# encoding: UTF-8
require 'gengo'

# Get all feedback on a job.

gengo = Gengo::API.new({
	:public_key => 'your_public_key',
	:private_key => 'your_private_key',
	:sandbox => true,
})

puts gengo.getTranslationJobFeedback({:id => 42})
