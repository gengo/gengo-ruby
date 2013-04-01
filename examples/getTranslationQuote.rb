require 'gengo'

gengo = Gengo::API.new({
  :public_key => 'SVYn-x_18HCpY5aKzEYqOIUrs[qVnW^^hgAl(jR0cNNQ]$YrPjP-)PRZHudSWUgQ',
  :private_key => 'Hv1yc$SS7xT)]iPeoFG#yC~[WB9LJrh14M]KyH}70PqoBG81]yCN1KVFB7$@e^A}'
})


puts gengo.getTranslationQuote({
  :jobs => {
    :job_1 => {
      :type => "file",
      :slug => "Hallo",
      :lc_src => "fr",
      :lc_tgt => "en",
      :tier => "standard",
      :file_path => "~/Documents/file.doc"
    },
    :job_2 => {
      :type => "file",
      :slug => "Nice",
      :lc_src => "fr",
      :lc_tgt => "en",
      :tier => "standard",
      :file_path => "~/Documents/file2.txt"
    }
  },
  :is_upload => true
})
