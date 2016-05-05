module Wowza
  module REST
    class StatusParser

      def parse(hash)
        hash = hash.with_indifferent_access
        {
          version: hash["version"],
          total_memory: hash["totalMemory"],
          processor_cores: hash["processorCores"],
          gpu_acceleration: hash["gpuAcceleration"],
          time_running: hash["timeRunning"],
          current_connections: hash["currentConnections"],
          max_connections: hash["maxConnections"],
          max_incoming_streams: hash["maxIncomingStreams"],
          rest_api_available: hash["restAPIAvailable"],
          http_origin: hash["httpOrigin"],
          native_base: hash["nativeBase"],
          wse_name: hash["wseName"],
          transcoder: {
            licenses: hash["transcoderLicenses"],
            licenses_in_use: hash["transcoderLicensesInUse"],
            applications: hash["transcoderApplications"],
          },
          dvr: {
            licensed: hash["dvrLicensed"],
            in_use: hash["dvrInUse"],
            applications: hash["dvrApplications"],
          },
          drm: {
            licensed: hash["drmLicensed"],
            in_use: hash["drmInUse"],
            applications: hash["drmApplications"],
          },
          server: {
            name: hash["serverName"],
            version: hash["serverVersion"],
            build: hash["serverBuild"],
            mode: hash["serverMode"],
          },
          license: {
            type: hash["licenseType"],
            expire_date: hash["licenseExpireDate"],
          },
          os: {
            name: hash["osName"],
            version: hash["osVersion"],
            architecture: hash["osArchitecture"],
            bitness: hash["osBitness"],
          },
          java: {
            version: hash["javaVersion"],
            vm_version: hash["javaVMVersion"],
            bitness: hash["javaBitness"],
            name: hash["javaName"],
            vendor: hash["javaVendor"],
            home: hash["javaHome"],
            max_heap_size: hash["javaMaxHeapSize"],
          }
        }
      end

    end
  end
end
