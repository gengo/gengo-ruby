# encoding: UTF-8
require 'gengo'

gengo = Gengo::API.new(
  public_key: 'your_public_key',
  private_key: 'your_private_key',
  sandbox: true,
)

# Posts a comment to order #42.
puts gengo.postTranslationOrderComment(id: 1702357, body: "I love lamp!")
