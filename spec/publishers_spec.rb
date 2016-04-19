require 'spec_helper'

describe Wowza::REST::Publishers do

  let(:server) do
    Wowza::REST::Server.new(host: 'example.com', port: 1234, server: 'server')
  end

  let(:client) do
    server.connect(username: 'foo', password: 'bar')
  end

  let(:publishers_response) do
    JSON.generate({
      serverName: 'server',
      publishers: [
        { name: 'wowza' }
      ]
    })
  end

  context '#all' do
    before do
      stub_request(:get, 'http://example.com:1234/v2/servers/server/publishers').with({
        headers: {
          'Accept' => 'application/json'
        }
      }).to_return({
        headers: {
          'Content-Type' => 'application/json'
        },
        status: 200,
        body: publishers_response
      })
    end

    it 'fetches all publishers' do
      publishers = client.publishers.all

      expect(publishers.count).to eq(1)
      expect(publishers.first.name).to eq('wowza')
    end
  end
end
