require 'rake'

Gem::Specification.new do |gs|
	gs.name = "gengo"
	gs.version = "1.13"
	gs.authors = [
        "Lloyd Chan",
		"Ryan McGrath",
		"Matthew Romaine",
		"Kim Alhstrom",
		"Shawn Smith"
    ]
	gs.date = "2012-10-02"
	gs.summary = "A library for interfacing with the Gengo Translation API."
	gs.description = "Gengo is a service that offers various translation APIs, both machine and high quality human-sourced. The Gengo gem lets you interface with the Gengo REST API (http://gengo.com/services/api/dev-docs/)."
	gs.email = "api@gengo.com"
	gs.homepage = "http://developers.gengo.com"
	gs.files = FileList['lib/**/*.rb', 'licenses/*', 'bin/*', '[A-Z]*', 'test/**/*'].to_a
	gs.has_rdoc = true

	gs.add_dependency('json')
	gs.add_dependency('multipart-post')
	gs.add_dependency('mime-types')
    gs.add_development_dependency 'rspec', '~> 2.7'
    gs.add_development_dependency 'rack-test'
    gs.add_development_dependency 'simplecov'
    gs.add_development_dependency 'webmock'
end
