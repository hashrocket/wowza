require 'spec_helper'

describe Wowza::REST::Instances do

  let(:server) do
    Wowza::REST::Server.new(host: 'example.com', port: 1234)
  end

  let(:client) do
    server.connect(username: 'foo', password: 'bar')
  end

  let(:conn) do
    client.connection
  end

  let(:application_href) do
    '/v2/servers/_defaultServer_/vhosts/_defaultVHost_/applications/live'
  end

  let(:application) do
    object_double(Wowza::REST::Application.new, href: application_href, conn: conn)
  end

  let(:instances_response) do
    JSON.generate({
      instanceList: [{
        name: '_definst_'
      }]
    })
  end

  context '#all' do

    def instances_api(response)
      Mock5.mock('http://example.com:1234') do
        get '/v2/servers/_defaultServer_/vhosts/_defaultVHost_/applications/live/instances' do
          status 200
          headers 'Content-Type' => 'application/json'
          response
        end
      end
    end

    it 'fetches all instances' do
      Mock5.with_mounted instances_api(instances_response) do
        instances = described_class.new(conn, application).all

        expect(instances.count).to eq(1)
        expect(instances.first.name).to eq('_definst_')
      end
    end
  end
end
