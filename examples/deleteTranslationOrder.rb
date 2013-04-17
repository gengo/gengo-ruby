# encoding: UTF-8
require 'gengo'

# Delete an order previously sent to Gengo and
# print out response JSON.

gengo = Gengo::API.new({
    :public_key => 'your_public_key',
    :private_key => 'your_private_key',
    :sandbox => true
})

puts gengo.deleteTranslationOrder({:id => 64462})
