# encoding: UTF-8
require 'gengo'

# Delete an order previously sent to Gengo and
# print out response JSON.

gengo = Gengo::API.new({
    :public_key => '}vKzwc7Y{=JIR@zvMFC]7eRP@P3dtxAPT3cEAChfLILGa21v5~AK=Fq10e8v3hR{',
    :private_key => 'dLkKLyaD6$h43RfcbAuRye4x4$Q6p$zso2C7Vte}gdlRw5rANjd3--jG31utyZFl',
    :sandbox => true
})

puts gengo.deleteTranslationOrder({:id => 64462})
