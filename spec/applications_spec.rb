require 'spec_helper'

describe Wowza::REST::Applications do

  let(:server) do
    Wowza::REST::Server.new(host: 'example.com', port: 1234)
  end

  let(:client) do
    server.connect(username: 'foo', password: 'bar')
  end

  let(:applications_response) do
    JSON.generate({
      serverName: '_defaultServer_',
      applications: [
        {
          id: 'live',
          href: '/v2/servers/_defaultServer_/vhosts/_defaultVHost_/applications/live',
          appType: 'live',
          dvrEnabled: false,
          drmEnabled: false,
          transcoderEnabled: true,
          streamTargetsEnabled: false
        }
      ]
    })
  end

  context '#all' do

    def applications_api(response)
      Mock5.mock('http://example.com:1234') do
        get '/v2/servers/_defaultServer_/vhosts/_defaultVHost_/applications' do
          status 200
          headers 'Content-Type' => 'application/json'
          response
        end
      end
    end

    it 'fetches all applications' do
      Mock5.with_mounted applications_api(applications_response) do
        applications = client.applications.all
        app = applications.first

        expect(applications.count).to eq(1)
        expect(app.id).to eq('live')
        expect(app.href).to eq('/v2/servers/_defaultServer_/vhosts/_defaultVHost_/applications/live')
        expect(app.app_type).to eq('live')
        expect(app.dvr_enabled).to eq(false)
        expect(app.drm_enabled).to eq(false)
        expect(app.transcoder_enabled).to eq(true)
        expect(app.stream_targets_enabled).to eq(false)
      end
    end
  end
end
