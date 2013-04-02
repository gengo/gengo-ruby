# encoding: UTF-8
require 'gengo'

gengo = Gengo::API.new({
	:public_key => 'your_public_key',
	:private_key => 'your_private_key',
	:sandbox => true,
})

# Posts a comment to job #42.
puts gengo.postTranslationJobComment({:id => 42, :body => "I love lamp!"})
