require 'gengo'

gengo = Gengo::API.new({
  :public_key => 'public_key',
  :private_key => 'private_key'
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
