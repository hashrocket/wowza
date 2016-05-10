require 'spec_helper'

describe Wowza::REST::Client do

  let(:server) do
    Wowza::REST::Server.new(host: 'example.com', port: 1234)
  end

  let(:client) do
    client = server.connect(username: 'foo', password: 'bar')
  end

  context '#status' do
    def status_api
      Mock5.mock('http://example.com:1234') do
        get '/v2/servers/_defaultServer_/status' do
          status 200
          headers 'Content-Type' => 'application/json'
          JSON.generate({
            version: "1",
            serverName: "server",
            serverVersion: "4.4.1",
            serverBuild: "2",
            licenseType: "Wowza",
            licenseExpireDate: "unknown",
            serverMode: "Production",
            osName: "Linux",
            osVersion: "10",
            osArchitecture: "amd64",
            osBitness: "Unknown",
            totalMemory: 160,
            processorCores: 2,
            gpuAcceleration: "Unknown",
            javaVersion: "1.8.0",
            javaVMVersion: "25.60",
            javaBitness: "64",
            javaName: "Java",
            javaVendor: "Oracle",
            javaHome: "/usr/local/Wowza/jre",
            javaMaxHeapSize: "500MB",
            timeRunning: 123.0,
            currentConnections: 1,
            maxConnections: -1,
            maxIncomingStreams: -1,
            restAPIAvailable: true,
            httpOrigin: false,
            transcoderLicenses: -1,
            transcoderLicensesInUse: 1,
            transcoderApplications: ["_defaultVHost_/server"],
            dvrLicensed: true,
            dvrInUse: false,
            dvrApplications: [],
            drmLicensed: true,
            drmInUse: false,
            drmApplications: [],
            nativeBase: "linux",
            wseName: "Wowza"
          })
        end
      end
    end

    it 'shows server status' do
      Mock5.with_mounted status_api do
        status = client.status

        expect(status).to be_a_kind_of(Hash)
        expect(status[:version]).to eq("1")
        expect(status[:total_memory]).to eq(160)
        expect(status[:processor_cores]).to eq(2)
        expect(status[:gpu_acceleration]).to eq("Unknown")
        expect(status[:time_running]).to eq(123.0)
        expect(status[:current_connections]).to eq(1)
        expect(status[:max_connections]).to eq(-1)
        expect(status[:max_incoming_streams]).to eq(-1)
        expect(status[:rest_api_available]).to eq(true)
        expect(status[:http_origin]).to eq(false)
        expect(status[:native_base]).to eq("linux")
        expect(status[:wse_name]).to eq("Wowza")
        expect(status[:transcoder][:licenses]).to eq(-1)
        expect(status[:transcoder][:licenses_in_use]).to eq(1)
        expect(status[:transcoder][:applications]).to eq(["_defaultVHost_/server"])
        expect(status[:dvr][:licensed]).to eq(true)
        expect(status[:dvr][:in_use]).to eq(false)
        expect(status[:dvr][:applications]).to eq([])
        expect(status[:drm][:licensed]).to eq(true)
        expect(status[:drm][:in_use]).to eq(false)
        expect(status[:drm][:applications]).to eq([])
        expect(status[:server][:name]).to eq("server")
        expect(status[:server][:version]).to eq("4.4.1")
        expect(status[:server][:build]).to eq("2")
        expect(status[:server][:mode]).to eq("Production")
        expect(status[:license][:type]).to eq("Wowza")
        expect(status[:license][:expire_date]).to eq("unknown")
        expect(status[:os][:name]).to eq("Linux")
        expect(status[:os][:version]).to eq("10")
        expect(status[:os][:architecture]).to eq("amd64")
        expect(status[:os][:bitness]).to eq("Unknown")
        expect(status[:java][:version]).to eq("1.8.0")
        expect(status[:java][:vm_version]).to eq("25.60")
        expect(status[:java][:bitness]).to eq("64")
        expect(status[:java][:name]).to eq("Java")
        expect(status[:java][:vendor]).to eq("Oracle")
        expect(status[:java][:home]).to eq("/usr/local/Wowza/jre")
        expect(status[:java][:max_heap_size]).to eq("500MB")
      end
    end

  end

end
