module EasyBroker
  class TitleExtractor
    KEYS = %w[title name public_title headline].freeze

    def self.call(hash)
      return nil unless hash.is_a?(Hash)

      KEYS.each do |key|
        value = hash[key]
        return value.to_s.strip if value && !value.to_s.strip.empty?
      end

      nil
    end
  end
end
