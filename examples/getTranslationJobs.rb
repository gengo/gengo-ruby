# encoding: UTF-8
require 'gengo'

gengo = Gengo::API.new({
  :public_key => 'your_public_key',
  :private_key => 'your_private_key',
  :sandbox => true,
})

# Think of this as a "search my jobs" method and it
# becomes very self explanatory.
puts gengo.getTranslationJobs({:status => "unpaid", :count => 15})
