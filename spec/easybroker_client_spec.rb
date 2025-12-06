require 'rspec'
require 'webmock/rspec'
require_relative '../lib/easybroker_client'

RSpec.describe EasyBrokerClient do
  let(:api_key) { 'test_key' }
  let(:base) { 'https://api.stagingeb.com' }
  subject { described_class.new(api_key: api_key, base_url: base, limit: 2) }

  before do
    stub_request(:get, "#{base}/v1/properties")
      .with(query: hash_including({'page' => '1', 'limit' => '2'}), headers: {'X-Authorization' => api_key})
      .to_return(status: 200, body: [
        { 'public_id' => 'EB-1', 'title' => 'Casa en DGO 1' },
        { 'public_id' => 'EB-2', 'title' => 'Departamento en DGO 2' }
      ].to_json, headers: {'Content-Type' => 'application/json'})

    stub_request(:get, "#{base}/v1/properties")
      .with(query: hash_including({'page' => '2', 'limit' => '2'}), headers: {'X-Authorization' => api_key})
      .to_return(status: 200, body: [].to_json, headers: {'Content-Type' => 'application/json'})
  end

  it 'iterar todas las propiedades y devuelve títulos' do
    titles = []
    subject.each_property { |p| titles << p['title'] }
    expect(titles).to eq(['Casa en DGO 1', 'Departamento en DGO 2'])
  end
end
