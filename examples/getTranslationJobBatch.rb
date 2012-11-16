# encoding: UTF-8
require 'gengo'

# Get a group of jobs previously submitted, given
# one job ID.

gengo = Gengo::API.new({
	:public_key => 'your_public_key',
	:private_key => 'your_private_key',
	:sandbox => true,
})

puts gengo.getTranslationJobBatch({:id => 42})
