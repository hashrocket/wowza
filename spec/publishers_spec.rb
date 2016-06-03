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

  let(:publisher_response) do
    JSON.generate({
      serverName: '_defaultServer_',
      name: 'wowza'
    })
  end

  let(:publisher_not_found_response) do
    nil
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

  context '#find' do

    def publishers_api(response, status_code=200)
      Mock5.mock('http://example.com:1234') do
        get '/v2/servers/_defaultServer_/publishers/wowza' do
          status status_code
          headers 'Content-Type' => 'application/json'
          response
        end
      end
    end

    it 'finds publisher by name' do
      Mock5.with_mounted publishers_api(publisher_response) do
        publisher = client.publishers.find('wowza')

        expect(publisher.name).to eq('wowza')
      end
    end

    it 'returns nil when publisher not found' do
      Mock5.with_mounted publishers_api(publisher_not_found_response, 404) do
        publisher = client.publishers.find('wowza')

        expect(publisher).to eq(nil)
      end
    end
  end
end
