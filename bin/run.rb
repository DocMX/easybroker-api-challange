#!/usr/bin/env ruby
require 'bundler/setup'
require_relative '../lib/easybroker_client'

api_key = ENV['EASYBROKER_API_KEY'] || 'l7u502p8v46ba3ppgvj5y2aad50lb9'
client = EasyBrokerClient.new(api_key: api_key, verbose: true, limit: 5)

begin
  client.print_all_titles
rescue => e
  warn "Error: #{e.message}"
  exit 1
end
