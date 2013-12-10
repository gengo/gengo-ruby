# encoding: UTF-8
require 'gengo'

# Returns all revisions on a job.

gengo = Gengo::API.new({
  :public_key => 'your_public_key',
  :private_key => 'your_private_key',
  :sandbox => true,
})

puts gengo.getTranslationJobRevisions({:id => 42})
