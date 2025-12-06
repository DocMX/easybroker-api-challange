module EasyBroker
  class Paginator
    WRAPPERS = %w[content data properties results items].freeze

    def initialize(client:, limit:)
      @client = client
      @limit = limit
    end

    def each_property
      return enum_for(:each_property) unless block_given?

      page = 1
      loop do
        raw = @client.fetch_properties_page(page: page, limit: @limit)
        break if raw.nil?

        props = normalize(raw)
        break if props.empty?

        props.each { |p| yield p }
        break if props.size < @limit

        page += 1
      end
    end

    private

    def normalize(raw)
      return [] if raw.nil?
      return raw if raw.is_a?(Array)

      if raw.is_a?(Hash)
        WRAPPERS.each do |k|
          return raw[k] if raw.key?(k) && raw[k].is_a?(Array)
        end

        if raw.values.all? { |v| v.is_a?(Hash) }
          return raw.values
        end
      end

      []
    end
  end
end
