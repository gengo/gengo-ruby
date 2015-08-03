# encoding: UTF-8
require 'gengo'

# Get all comments on an order.

gengo = Gengo::API.new({
  :public_key => 'your_public_key',
  :private_key => 'your_private_key',
  :sandbox => true,
})

puts gengo.getTranslationOrderComments({:id => 42})
