require 'spec_helper'

describe Wowza::REST::StreamGroup do

  let(:server) do
    Wowza::REST::Server.new(host: 'example.com', port: 1234, server: '_defaultServer_')
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

  let(:stream_group_response) do
    JSON.generate({
      groupName: "#{stream_name}_all",
      instanceName: "_definst_",
      serverName: "_defaultServer_",
      isTranscodeResult: true,
      members: [
        "#{stream_name}_160p",
        "#{stream_name}_source"
      ]
    })
  end

  let(:server_path) do
    "/v2/servers/_defaultServer_"
  end

  let(:application_path) do
    "#{server_path}/vhosts/_defaultVHost_/applications/live"
  end

  let(:stream_group_path) do
    "#{application_path}/instances/_definst_/streamgroups/#{stream_name}_all"
  end

  def stream_group_api(path, response)
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
      Mock5.with_mounted stream_group_api(stream_group_path, stream_group_response) do
        group = described_class.new(stream_name: stream_name, app_id: 'live', conn: conn)
        group.reload!

        expect(group.name).to eq("#{stream_name}_all")
        expect(group.server_name).to eq("_defaultServer_")
        expect(group.instance_name).to eq("_definst_")
        expect(group.streams.count).to eq(2)
      end
    end
  end

  context '#find_by' do
    it 'reloads stream data from API' do
      Mock5.with_mounted stream_group_api(stream_group_path, stream_group_response) do
        group = described_class.find_by(stream_name: stream_name, app_id: 'live', conn: conn)

        expect(group.name).to eq("#{stream_name}_all")
        expect(group.server_name).to eq("_defaultServer_")
        expect(group.instance_name).to eq("_definst_")
        expect(group.streams.count).to eq(2)
      end
    end
  end
end
