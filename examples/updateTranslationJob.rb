# encoding: UTF-8
require 'gengo'

# Updates a job with a given set of actions
# and relevant data.

gengo = Gengo::API.new({
  :public_key => 'your_public_key',
  :private_key => 'your_private_key',
  :sandbox => true,
})

gengo.updateTranslationJob({
  :id => 42,
  :action => "reject",
  :reason => "quality",
  :comment => "My Grandmother does better.",
  :captcha => "bert"
})
