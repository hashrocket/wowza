require 'spec_helper'

describe Wowza::REST::Server do

  let(:server) do
    Wowza::REST::Server.new(host: 'example.com', port: 1234)
  end

  context '#connect' do
    it 'creates a client' do
      client = server.connect(username: 'foo', password: 'bar')

      expect(client).to be_a_kind_of(Wowza::REST::Client)
    end
  end
end
