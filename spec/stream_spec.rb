require 'spec_helper'

describe Wowza::REST::Stream do

  let(:server) do
    Wowza::REST::Server.new(host: 'example.com', port: 1234)
  end

  let(:client) do
    server.connect(username: 'foo', password: 'bar')
  end

  let(:conn) do
    client.connection
  end

  let(:stream_name) do
    "Surfing"
  end

  let(:stream_response) do
    JSON.generate({
      name: stream_name,
      applicationInstance: "_definst_",
      isConnected: true,
      isRecordingSet: false,
      serverName: "_defaultServer_",
      sourceIp: "rtmp://10.10.10.10:12345"
    })
  end

  let(:server_path) do
    "/v2/servers/_defaultServer_"
  end

  let(:application_path) do
    "#{server_path}/vhosts/_defaultVHost_/applications/live"
  end

  let(:stream_path) do
    "#{application_path}/instances/_definst_/incomingstreams/#{stream_name}"
  end

  def stream_api(path, response)
    Mock5.mock('http://example.com:1234') do
      get path do
        status 200
        headers 'Content-Type' => 'application/json'
        response
      end
    end
  end

  context '#reload!' do
    it 'reloads stream data from API' do
      Mock5.with_mounted stream_api(stream_path, stream_response) do
        stream = described_class.new(name: stream_name, app_id: 'live', conn: conn)
        stream.reload!

        expect(stream.name).to eq(stream_name)
        expect(stream.connected?).to eq(true)
        expect(stream.recording?).to eq(false)
        expect(stream.source_ip).to eq('rtmp://10.10.10.10:12345')
      end
    end
  end

  context '#find_by' do
    it 'finds stream by name and app id' do
      Mock5.with_mounted stream_api(stream_path, stream_response) do
        stream = described_class.find_by(name: stream_name, app_id: 'live', conn: conn)

        expect(stream.name).to eq(stream_name)
        expect(stream.connected?).to eq(true)
        expect(stream.recording?).to eq(false)
        expect(stream.source_ip).to eq('rtmp://10.10.10.10:12345')
      end
    end
  end
end
