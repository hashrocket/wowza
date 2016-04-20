require 'spec_helper'

describe Wowza::REST::Publisher do

  let(:server) do
    Wowza::REST::Server.new(host: 'example.com', port: 1234, server: 'server')
  end

  let(:client) do
    server.connect(username: 'foo', password: 'bar')
  end

  context '#save' do

    def create_publisher_api
      Mock5.mock('http://example.com:1234') do
        post '/v2/servers/server/publishers' do
          status 201
          headers 'Content-Type' => 'application/json'
          JSON.generate({
            success: true,
            message: "",
            data: nil
          })
        end
      end
    end

    it 'creates publisher' do
      Mock5.with_mounted create_publisher_api do
        publisher = Wowza::REST::Publisher.new(name: 'channel', password: '321')
        publisher.client = client
        publisher.save

        expect(publisher.persisted?).to eq(true)
      end
    end
  end
end
