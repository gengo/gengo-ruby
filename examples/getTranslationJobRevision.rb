# encoding: UTF-8
require 'gengo'

# Returns a revision specified by number.

gengo = Gengo::API.new({
  :public_key => 'your_public_key',
  :private_key => 'your_private_key',
  :sandbox => true,
})

puts gengo.getTranslationJobRevision({:id => 42, :rev_id => 1})
