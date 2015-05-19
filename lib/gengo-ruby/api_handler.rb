# encoding: UTF-8

require 'rubygems'
require 'net/http'
require 'uri'
require 'cgi'
require 'json'
require 'openssl'
require 'time'
require 'net/http/post/multipart'
require 'mime/types'

module Gengo

  # The only real class that ever needs to be instantiated.
  class API
    attr_accessor :api_host
    attr_accessor :debug
    attr_accessor :client_info

    # Creates a new API handler to shuttle calls/jobs/etc over to the Gengo translation API.
    #
    # Options:
    # <tt>opts</tt> - A hash containing the api key, the api secret key, the API version (defaults to 1), whether to use
    # the sandbox API, and an optional custom user agent to send.
    def initialize(opts)
      # Consider this an example of the object you need to pass.
      @opts = {
        :public_key => '',
        :private_key => '',
        :api_version => '2',
        :sandbox => false,
        :user_agent => "Gengo Ruby Library; Version #{Gengo::Config::VERSION}; http://gengo.com/;",
        :debug => false,
      }.merge(opts)

      # Let's go ahead and separate these out, for clarity...
      @debug = @opts[:debug]
      @api_host = (@opts[:sandbox] == true ? Gengo::Config::SANDBOX_API_HOST : Gengo::Config::API_HOST)

      # More of a public "check this" kind of object.
      @client_info = {"VERSION" => Gengo::Config::VERSION}
    end

    # Use CGI escape to escape a string
    def urlencode(string)
      CGI::escape(string)
    end

    # Creates an HMAC::SHA1 signature, signing the timestamp with the private key.
    def signature_of(ts)
      OpenSSL::HMAC.hexdigest 'sha1', @opts[:private_key], ts
    end

    # The "GET" method; handles requesting basic data sets from Gengo and converting
    # the response to a Ruby hash/object.
    #
    # Options:
    # <tt>endpoint</tt> - String/URL to request data from.
    # <tt>params</tt> - Data necessary for request (keys, etc). Generally taken care of by the requesting instance.
    def get_from_gengo(endpoint, params = {})
      # Do this small check here...
      is_delete = params.delete(:is_delete)
      is_download_file = params.delete(:is_download)

      # The first part of the object we're going to encode and use in our request to Gengo. The signing process
      # is a little annoying at the moment, so bear with us...
      query = params.reduce({}) do |hash_thus_far, (param_key, param_value)|
        hash_thus_far.merge(param_key.to_sym => param_value.to_s)
      end

      query[:api_key] = @opts[:public_key]
      query[:ts] = Time.now.gmtime.to_i.to_s

      endpoint << "?api_sig=" + signature_of(query[:ts])
      endpoint << '&' + query.map { |k, v| "#{k}=#{urlencode(v)}" }.join('&')

      uri = "/v#{@opts[:api_version]}/" + endpoint
      headers = {
        'Accept' => 'application/json',
        'User-Agent' => @opts[:user_agent]
      }

      if is_delete
        req = Net::HTTP::Delete.new(uri, headers)
      else
        req = Net::HTTP::Get.new(uri, headers)
      end

      http = Net::HTTP.start(@api_host, 80)
      if @debug
        http.set_debug_output($stdout)
      end
      http.read_timeout = 5*60
      resp = http.request(req)

      return resp.body if is_download_file

      begin
        json = JSON.parse(resp.body)
      rescue => e
        # TODO(yugui) Log the original error
        raise Gengo::Exception.new('error', resp.code.to_i, resp.body) unless resp.kind_of?(Net::HTTPSuccess)

        # It should be very unlikely, but resp.body can be invalid as a JSON in theory even though the status is successful.
        # In this case, raise an exception to report that unexpected status.
        raise Gengo::Exception.new('error', 500, 'unexpected format of server response. Report it to Gengo if this exception repeatedly happens')
      end

      raise Gengo::Exception.new(json['opstat'], json['err']['code'].to_i, json['err']['msg']) unless json['opstat'] == 'ok'

      # Return it if there are no problems, nice...
      return json
    end

    # The "POST" method; handles shuttling up encoded job data to Gengo
    # for translation and such. Somewhat similar to the above methods, but depending on the scenario
    # can get some strange exceptions, so we're gonna keep them fairly separate for the time being. Consider
    # for a merger down the road...
    #
    # Options:
    # <tt>endpoint</tt> - String/URL to post data to.
    # <tt>params</tt> - Data necessary for request (keys, etc). Generally taken care of by the requesting instance.
    def send_to_gengo(endpoint, params = {})

      # Check if this is a put
      is_put = params.delete(:is_put)

      query = {
        :api_key => @opts[:public_key],
        :data => params.to_json.gsub('"', '\"'),
        :ts => Time.now.gmtime.to_i.to_s
      }

      url = URI.parse("http://#{@api_host}/v#{@opts[:api_version]}/#{endpoint}")
      http = Net::HTTP.new(url.host, url.port)
      http.read_timeout = 5*60
      if is_put
        request = Net::HTTP::Put.new(url.path)
      else
        request = Net::HTTP::Post.new(url.path)
      end

      request.add_field('Accept', 'application/json')
      request.add_field('User-Agent', @opts[:user_agent])

      request.content_type = 'application/x-www-form-urlencoded'
      request.body = {
        "api_sig" => signature_of(query[:ts]),
        "api_key" => urlencode(@opts[:public_key]),
        "data" => urlencode(params.to_json.gsub('\\', '\\\\')),
        "ts" => query[:ts].to_i.to_s
      }.map { |k, v| "#{k}=#{v}" }.flatten.join('&')

      if @debug
        http.set_debug_output($stdout)
      end

      resp = http.request(request)

      case resp
      when Net::HTTPSuccess, Net::HTTPRedirection
        json = JSON.parse(resp.body)

        if json['opstat'] != 'ok'
          raise Gengo::Exception.new(json['opstat'], json['err']['code'].to_i, json['err']['msg'])
        end

        # Return it if there are no problems, nice...
        json
      else
        resp.error!
      end
    end

    # The "UPLOAD" method; handles sending a file to the quote method
    #
    # Options:
    # <tt>endpoint</tt> - String/URL to post data to.
    # <tt>params</tt> - Data necessary for request (keys, etc). Generally taken care of by the requesting instance.
    def upload_to_gengo(endpoint, params = {})

      # prepare the file_hash and append file_key to each job payload
      files_hash = params[:jobs].each_value.reduce({}) do |hash_thus_far, job_values|
      if job_values[:file_path]
        job_mime_type = MIME::Types.type_for(job_values[:file_path]).first.content_type
        file_hash_key = "file_#{hash_thus_far.length.to_s}".to_sym
        job_values[:file_key] = file_hash_key
        hash_thus_far[file_hash_key] = UploadIO.new(File.open(job_values[:file_path]), job_mime_type, File.basename(job_values[:file_path]))
      end
        hash_thus_far
      end

      url = URI.parse("http://#{@api_host}/v#{@opts[:api_version]}/#{endpoint}")

      http = Net::HTTP.new(url.host, url.port)
      http.read_timeout = 5*60

      call_timestamp = Time.now.gmtime.to_i.to_s

      the_hash = files_hash.merge({
        "api_sig" => signature_of(call_timestamp),
        "api_key" => @opts[:public_key],
        "data" =>params.to_json.gsub('\\', '\\\\'),
        "ts" => call_timestamp
      })

      request = Net::HTTP::Post::Multipart.new(url.path, the_hash, {'Accept' => 'application/json', 'User-Agent' => @opts[:user_agent] })

      if @debug
        http.set_debug_output($stdout)
      end

      resp = http.request(request)

      case resp
      when Net::HTTPSuccess, Net::HTTPRedirection
        json = JSON.parse(resp.body)

        if json['opstat'] != 'ok'
          raise Gengo::Exception.new(json['opstat'], json['err']['code'].to_i, json['err']['msg'])
        end

        # Return it if there are no problems, nice...
        json
      else
        resp.error!
      end
    end

    # Returns a Ruby-hash of the stats for the current account. No arguments required!
    #
    # Options:
    # <tt>None</tt> - N/A
    def getAccountStats(params = {})
      self.get_from_gengo('account/stats', params)
    end

    # Returns a Ruby-hash of the balance for the authenticated account. No args required!
    #
    # Options:
    # <tt>None</tt> - N/A
    def getAccountBalance(params = {})
      self.get_from_gengo('account/balance', params)
    end

    # Returns an array of preferred translators for the current account by language pair. No args required!
    #
    # Options:
    # <tt>None</tt> - N/A
    def getAccountPreferredTranslators(params = {})
      self.get_from_gengo('account/preferred_translators', params)
    end

    # Much like the above, but takes a hash titled "jobs" that is multiple jobs, each with their own unique key.
    #
    # Options:
    # <tt>jobs</tt> - "Jobs" is a hash containing further hashes; each further hash is a job. This is best seen in the example code.
    def postTranslationJobs(params = {})
      self.send_to_gengo('translate/jobs', params)
    end

    # Updates an already submitted job.
    #
    # Options:
    # <tt>id</tt> - The ID of a job to update.
    # <tt>action</tt> - A hash describing the update to this job. See the examples for further documentation.
    def updateTranslationJob(params = {})
      params[:is_put] = true
      self.send_to_gengo('translate/job/:id'.gsub(':id', params.delete(:id).to_s), params)
    end

    # Updates a group of already submitted jobs.
    #
    # Options:
    # <tt>jobs</tt> - An Array of job objects to update (job objects or ids)
    # <tt>action</tt> - A String describing the update to this job. "approved", "rejected", etc - see Gengo docs.
    def updateTranslationJobs(params = {})
      params[:is_put] = true
      self.send_to_gengo('translate/jobs', {:jobs => params[:jobs], :action => params[:action]})
    end

    # Given an ID, pulls down information concerning that job from Gengo.
    #
    # <tt>id</tt> - The ID of a job to check.
    # <tt>pre_mt</tt> - Optional, get a machine translation if the human translation is not done.
    def getTranslationJob(params = {})
      self.get_from_gengo('translate/job/:id'.gsub(':id', params.delete(:id).to_s), params)
    end

    # Fetches a list of recent jobs you made.
    #
    # @deprecated Use {#jobs} or {#query_jobs} instead.
    #
    # == Keyword Parameters
    # <tt>ids</tt>::
    #   Optional. An array of job IDs to be fetched.
    #   Other parameters are ignored if you specify this parameter.
    # <tt>status</tt>::
    #   Optional. "unpaid", "available", "pending", "reviewable", "approved", "rejected", or "canceled".
    # <tt>timestamp_after</tt>::
    #   Optional. Epoch timestamp from which to filter submitted jobs.
    # <tt>count</tt>::
    #   Optional. Defaults to 10.
    def getTranslationJobs(params = {})
      if params[:ids].respond_to?(:each)
        jobs(params.delete(:ids))
      else
        query_jobs(params)
      end
    end

    # Fetchs a set of recent jobs whose IDs are the given ones.
    # @param ids [[Integer|String]] An array of job IDs to be fetched
    def jobs(ids)
      get_from_gengo('translate/jobs/%s' % ids.join(','))
    end

    # Fetchs a set of recent jobs you made.
    # You can apply filters with the following keyword parameters.
    #
    # == Keyword Parameters
    # <tt>status</tt>::
    #   Optional. Fetches only jobs in this status.
    #   Must be "unpaid", "available", "pending", "reviewable", "approved", "rejected", or "canceled".
    # <tt>timestamp_after</tt>::
    #   Optional. Epoch timestamp from which to filter submitted jobs.
    # <tt>count</tt>::
    #   Optional. The maximum number of jobs to be returned. Defaults to 10.
    def query_jobs(params = {})
      get_from_gengo('translate/jobs', params)
    end

    # Fetches a set of jobs in the order you made.
    #
    # @deprecated Use {#jobs_in_order} instead.
    #
    # == Required keyword parameters
    # <tt>order_id</tt> - Required, the ID of a job that you want the batch/group of.
    def getTranslationOrderJobs(params = {})
      order_id = params[:order_id]
      raise ArgumentError, 'order_id is a required parameter' unless order_id
      jobs_in_order(order_id)
    end

    # Fetches a set of jobs in the order you made.
    def jobs_in_order(id)
      self.get_from_gengo("translate/order/#{id}")
    end

    # Mirrors the bulk Translation call, but just returns an estimated cost.
    def determineTranslationCost(params = {})
      is_upload = params.delete(:is_upload)
      if is_upload
        self.upload_to_gengo('translate/service/quote/file', params)
      else
        self.send_to_gengo('translate/service/quote', params)
      end
    end

    # Mirrors the bulk Translation call, but just returns an estimated cost.
    def getTranslationQuote(params = {})
      determineTranslationCost(params)
    end

    # Post a comment for a translator or Gengo on a job.
    #
    # Options:
    # <tt>id</tt> - The ID of the job you're commenting on.
    # <tt>comment</tt> - The comment to put on the job.
    def postTranslationJobComment(params = {})
      self.send_to_gengo('translate/job/:id/comment'.gsub(':id', params.delete(:id).to_s), params)
    end

    # Get all comments (the history) from a given job.
    #
    # Options:
    # <tt>id</tt> - The ID of the job to get comments for.
    def getTranslationJobComments(params = {})
      self.get_from_gengo('translate/job/:id/comments'.gsub(':id', params.delete(:id).to_s), params)
    end

    # Returns the feedback you've submitted for a given job.
    #
    # Options:
    # <tt>id</tt> - The ID of the translation job you're retrieving comments from.
    def getTranslationJobFeedback(params = {})
      self.get_from_gengo('translate/job/:id/feedback'.gsub(':id', params.delete(:id).to_s), params)
    end

    # Gets a list of the revision resources for a job. Revisions are created each time a translator updates the text.
    #
    # Options:
    # <tt>id</tt> - The ID of the translation job you're getting revisions from.
    def getTranslationJobRevisions(params = {})
      self.get_from_gengo('translate/job/:id/revisions'.gsub(':id', params.delete(:id).to_s), params)
    end

    # Get a specific revision to a job.
    #
    # Options:
    # <tt>id</tt> - The ID of the translation job you're getting revisions from.
    # <tt>rev_id</tt> - The ID of the revision you're looking up.
    def getTranslationJobRevision(params = {})
      self.get_from_gengo('translate/job/:id/revision/:revision_id'.gsub(':id', params.delete(:id).to_s).gsub(':revision_id', params.delete(:rev_id).to_s), params)
    end

    # Deletes an order, cancelling all available jobs.
    #
    # This method is EXPERIMENTAL
    #
    # Options:
    # <tt>id</tt> - The ID of the order you want to delete.
    def deleteTranslationOrder(params = {})
      params[:is_delete] = true
      self.get_from_gengo('translate/order/:id'.gsub(':id', params.delete(:id).to_s), params)
    end

    # Deletes a job.
    #
    # Options:
    # <tt>id</tt> - The ID of the job you want to delete.
    def deleteTranslationJob(params = {})
      params[:is_delete] = true
      self.get_from_gengo('translate/job/:id'.gsub(':id', params.delete(:id).to_s), params)
    end

    # Deletes multiple jobs.
    #
    # Options:
    # <tt>ids</tt> - An Array of job IDs you want to delete.
    def deleteTranslationJobs(params = {})
      if params[:ids] and params[:ids].kind_of?(Array)
        params[:job_ids] = params[:ids].map { |i| i.to_s() }.join(',')
        params.delete(:ids)
      end

      params[:is_delete] = true
      self.get_from_gengo('translate/jobs', params)
    end

    # Gets information about currently supported language pairs.
    #
    # Options:
    # <tt>lc_src</tt> - Optional language code to filter on.
    def getServiceLanguagePairs(params = {})
      self.get_from_gengo('translate/service/language_pairs', params)
    end

    # Pulls down currently supported languages.
    def getServiceLanguages(params = {})
      self.get_from_gengo('translate/service/languages', params)
    end

    # Gets list of glossaries that belongs to the authenticated user
    def getGlossaryList(params = {})
      self.get_from_gengo('translate/glossary', params)
    end

    # Gets one glossary that belongs to the authenticated user
    def getGlossary(params = {})
      self.get_from_gengo('translate/glossary/:id'.gsub(':id', params.delete(:id).to_s), params)
    end

    # Downloads one glossary that belongs to the authenticated user
    def getGlossaryFile(params = {})
      params[:is_download] = true
      self.get_from_gengo('translate/glossary/download/:id'.gsub(':id', params.delete(:id).to_s), params)
    end
  end

end
