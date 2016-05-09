require 'spec_helper'

describe Wowza::REST::Instance do

  let(:server) do
    Wowza::REST::Server.new(host: 'example.com', port: 1234, server: '_defaultServer_')
  end

  let(:client) do
    server.connect(username: 'foo', password: 'bar')
  end

  let(:conn) do
    client.connection
  end

  let(:application) do
    Wowza::REST::Application.new id: 'live', conn: conn
  end

  let(:instances) do
    Wowza::REST::Instances.new(conn, application).all
  end

  let(:instance) do
    instances.first
  end

  let(:stream_name) do
    "Surfing"
  end

  let(:instances_response) do
    JSON.generate({
      instanceList: [{
        name: '_definst_',
        incomingStreams: [{
          name: stream_name,
          isConnected: true,
          isRecordingSet: false,
          sourceIp: 'rtmp://10.10.10.10:12345',
        },{
          name: "#{stream_name}_160p",
          isConnected: true,
          isRecordingSet: false,
          sourceIp: 'local (Transcoder)',
        }]
      }]
    })
  end

  def instances_api(response)
    Mock5.mock('http://example.com:1234') do
      get '/v2/servers/_defaultServer_/vhosts/_defaultVHost_/applications/live/instances' do
        status 200
        headers 'Content-Type' => 'application/json'
        response
      end
    end
  end

  context '#incoming_streams' do
    it 'returns list of incoming streams for instance' do
      Mock5.with_mounted instances_api(instances_response) do
        streams = instance.incoming_streams

        expect(streams.count).to eq(2)
        expect(streams.first.name).to eq('Surfing')
        expect(streams.first.connected?).to eq(true)
        expect(streams.first.recording?).to eq(false)
        expect(streams.first.source_ip).to eq('rtmp://10.10.10.10:12345')
        expect(streams.last.name).to eq('Surfing_160p')
        expect(streams.last.connected?).to eq(true)
        expect(streams.last.recording?).to eq(false)
        expect(streams.last.source_ip).to eq('local (Transcoder)')
      end
    end
  end
end
