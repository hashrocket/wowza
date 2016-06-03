require 'spec_helper'

describe Wowza::REST::Connection do

  let(:uri) do
    URI('http://example.com:1234')
  end

  let(:auth) do
    Wowza::REST::Authentication.new('foo', 'bar')
  end

  it 'adds json content and accept types' do
    endpoint = Mock5.mock(base_url(uri)) do
      get '/person' do
        {
          "headers" => {
            "Content-Type" => request.content_type,
            "Accept" => request.accept.first.to_s
          }
        }.to_json
      end
    end
    Mock5.with_mounted endpoint do
      conn = Wowza::REST::Connection.new(uri, auth)
      res = conn.get('/person')
      req_headers = JSON.parse(res.body)["headers"]
      expect(req_headers["Content-Type"]).to eq("application/json")
      expect(req_headers["Accept"]).to eq("application/json")
    end
  end

end

def base_url(uri)
  proto = uri.scheme
  host = uri.hostname
  port = uri.port == 80 ? '' : ":#{uri.port}"
  "#{proto}://#{host}#{port}"
end
