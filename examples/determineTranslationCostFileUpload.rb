require 'gengo'

gengo = Gengo::API.new({
  :public_key => 'your_public_key',
  :private_key => 'your_private_key',
  :sandbox => true,
})


puts gengo.determineTranslationCost({
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
