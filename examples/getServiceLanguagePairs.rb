# encoding: UTF-8
require 'gengo'

gengo = Gengo::API.new({
  :public_key => 'your_public_key',
  :private_key => 'your_private_key',
  :sandbox => true,
})

# Returns supported language pairs.
puts gengo.getServiceLanguagePairs()
