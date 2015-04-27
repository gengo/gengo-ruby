require 'rubygems'
require 'gengo-ruby/api_handler'
require 'gengo-ruby/gengo_exception'
require 'gengo-ruby/version'

module Gengo
  # Store global config objects here - e.g, urls, etc.
  module Config
    # API url endpoints; replace the version at function call time to
    # allow for function-by-function differences in versioning.
    API_HOST = 'api.gengo.com'
    SANDBOX_API_HOST = 'api.sandbox.gengo.com'
  end
end
