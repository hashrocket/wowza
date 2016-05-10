require 'spec_helper'

describe Wowza::REST::Publishers do

  let(:server) do
    Wowza::REST::Server.new(host: 'example.com', port: 1234)
  end

  let(:client) do
    server.connect(username: 'foo', password: 'bar')
  end

  let(:publishers_response) do
    JSON.generate({
      serverName: '_defaultServer_',
      publishers: [
        { name: 'wowza' }
      ]
    })
  end

  context '#all' do

    def publishers_api(response)
      Mock5.mock('http://example.com:1234') do
        get '/v2/servers/_defaultServer_/publishers' do
          status 200
          headers 'Content-Type' => 'application/json'
          response
        end
      end
    end

    it 'fetches all publishers' do
      Mock5.with_mounted publishers_api(publishers_response) do
        publishers = client.publishers.all

        expect(publishers.count).to eq(1)
        expect(publishers.first.name).to eq('wowza')
      end
    end
  end
end
