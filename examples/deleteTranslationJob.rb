# encoding: UTF-8
require 'gengo'

# Delete a job previously sent to Gengo and
# print out response JSON.

gengo = Gengo::API.new({
  :public_key => '',
  :private_key => '',
  :sandbox => true
})

puts gengo.deleteTranslationJob({:id => 64462})
