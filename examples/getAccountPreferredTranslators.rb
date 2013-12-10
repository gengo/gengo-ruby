# encoding: UTF-8
require 'gengo'

gengo = Gengo::API.new({
  :public_key => 'your_public_key',
  :private_key => 'your_private_key',
  :sandbox => true,
})

# Return the preferred translators set to current account by language pair.
puts gengo.getAccountPreferredTranslators()
