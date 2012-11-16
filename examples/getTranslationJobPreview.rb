# encoding: UTF-8
require 'gengo'

# Returns an image preview of the job
# in question (.gif).

gengo = Gengo::API.new({
	:public_key => 'your_public_key',
	:private_key => 'your_private_key',
	:sandbox => true,
})

puts gengo.getTranslationJobPreview({:id => 42})
