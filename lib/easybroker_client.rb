require 'faraday'
require 'json'

class EasyBrokerClient
  DEFAULT_BASE = ENV.fetch('EASYBROKER_BASE', 'https://api.stagingeb.com')
  DEFAULT_LIMIT = 100
  POSSIBLE_TITLE_KEYS = %w[title name public_title headline]

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

  def each_property
    return enum_for(:each_property) unless block_given?

    page = 1
    loop do
      raw = fetch_properties_page(page: page, limit: @limit)
      break if raw.nil?
      props = normalize_response_array(raw)
      break if props.nil? || props.empty?

      props.each { |p| yield p }
      break if props.size < @limit
      page += 1
    end
  end

  def print_all_titles
    count = 0
    each_property do |prop|
      title = extract_title(prop)
      puts title || "(sin título)"
      count += 1
    end
    warn "Total propiedades impresas: #{count}" if @verbose
  end

  private

  def extract_title(prop)
    return nil unless prop.is_a?(Hash)
    POSSIBLE_TITLE_KEYS.each { |k| return prop[k] if prop.key?(k) && prop[k] && !prop[k].to_s.strip.empty? }
    nil
  end

  def normalize_response_array(raw)
    return [] if raw.nil?
    return raw if raw.is_a?(Array)

    if raw.is_a?(Hash)
      %w[content data properties results items].each do |k|
        return raw[k] if raw.key?(k) && raw[k].is_a?(Array)
      end

      if raw.values.all? { |v| v.is_a?(Hash) }
        return raw.values
      end
    end

    []
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
