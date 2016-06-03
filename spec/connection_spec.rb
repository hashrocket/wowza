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

  it 'handles 401 digest response' do
    endpoint = Mock5.mock(base_url(uri)) do
      get '/person' do
        auth = request.env["HTTP_AUTHORIZATION"]
        if auth
          {
            data: "some data"
          }.to_json
        else
          nonce = 'secret'
          headers['WWW-Authenticate'] = %{Digest realm="Example", domain="/", nonce="#{nonce}", algorithm=MD5, qop="auth"}
          status 401
          {
            message: "Unauthorized"
          }.to_json
        end
      end
    end
    Mock5.with_mounted endpoint do
      conn = Wowza::REST::Connection.new(uri, auth)
      res = conn.get('/person')
      expect(res.code).to eq("200")
      expect(JSON.parse(res.body)).to eq({ "data" => "some data" })
    end
  end

end

def base_url(uri)
  proto = uri.scheme
  host = uri.hostname
  port = uri.port == 80 ? '' : ":#{uri.port}"
  "#{proto}://#{host}#{port}"
end
