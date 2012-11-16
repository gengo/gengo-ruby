# encoding: UTF-8
require 'gengo'

gengo = Gengo::API.new({
	:public_key => '',
	:private_key => '',
	:sandbox => true,
})

# Return the number of credits left on your account.
puts gengo.getAccountBalance()
