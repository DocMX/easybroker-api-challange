require 'faraday'
require 'json'

require_relative 'paginator'
require_relative 'title_extractor'

module EasyBroker
  class Client
    DEFAULT_BASE = ENV.fetch('EASYBROKER_BASE', 'https://api.stagingeb.com')
    DEFAULT_LIMIT = 100

    attr_reader :verbose

    def initialize(api_key:, base_url: DEFAULT_BASE, limit: DEFAULT_LIMIT, verbose: false)
      @api_key = api_key
      @base_url = base_url
      @limit = limit
      @verbose = verbose

      @conn = Faraday.new(url: @base_url) do |f|
        f.request :url_encoded
        f.adapter Faraday.default_adapter
      end
    end

    def each_property(&block)
      paginator = Paginator.new(client: self, limit: @limit)
      paginator.each_property(&block)
    end

    def print_all_titles
      count = 0

      each_property do |property|
        title = TitleExtractor.call(property)
        puts(title || "(sin título)")
        count += 1
      end

      warn "Total propiedades impresas: #{count}" if @verbose
    end

    def fetch_properties_page(page:, limit:)
      resp = @conn.get('/v1/properties') do |req|
        req.headers['X-Authorization'] = @api_key
        req.params['page'] = page
        req.params['limit'] = limit
      end

      if @verbose
        warn "HTTP #{resp.status} - #{resp.headers['content-type']}"
        warn "Body (truncated): #{resp.body.to_s[0..1000]}"
      end

      return nil unless resp.success?

      JSON.parse(resp.body)
    rescue JSON::ParserError
      nil
    end
  end
end
