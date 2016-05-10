require 'spec_helper'

describe Wowza::REST::Publisher do

  let(:server) do
    Wowza::REST::Server.new(host: 'example.com', port: 1234)
  end

  let(:client) do
    server.connect(username: 'foo', password: 'bar')
  end

  context '#save' do

    context 'not persisted' do
      def create_publisher_api
        Mock5.mock('http://example.com:1234') do
          post '/v2/servers/_defaultServer_/publishers' do
            status 201
            headers 'Content-Type' => 'application/json'
            JSON.generate({
              success: true,
              message: "",
              data: nil
            })
          end
        end
      end

      it 'creates publisher' do
        Mock5.with_mounted create_publisher_api do
          publisher = Wowza::REST::Publisher.new(name: 'channel', password: '321')
          publisher.conn = client.connection
          publisher.save

          expect(publisher.persisted?).to eq(true)
        end
      end
    end

    context 'already persisted' do
      def publishers_api(publishers)
        Mock5.mock('http://example.com:1234') do

          get '/v2/servers/_defaultServer_/publishers' do
            status 200
            headers 'Content-Type' => 'application/json'
            JSON.generate({
              serverName: '_defaultServer_',
              publishers: publishers
            })
          end

          put '/v2/servers/_defaultServer_/publishers/name' do
            status 200
            headers 'Content-Type' => 'application/json'
            JSON.generate({
              success: true,
              message: "",
              data: nil
            })
          end

        end
      end

      it 'updates publisher' do
        Mock5.with_mounted publishers_api([{ name: 'name' }]) do
          publisher = client.publishers.all.first
          expect(publisher.persisted?).to eq(true)
          expect(publisher.changed?).to eq(false)
          publisher.name = 'betterName'
          expect(publisher.persisted?).to eq(true)
          expect(publisher.changed?).to eq(true)
          publisher.save
          expect(publisher.persisted?).to eq(true)
          expect(publisher.changed?).to eq(false)
        end
      end

    end
  end

  context '#destroy' do

    context 'not persisted' do
      it 'does nothing' do
        publisher = Wowza::REST::Publisher.new(name: 'channel', password: '321')
        publisher.conn = client.connection
        publisher.destroy

        expect(publisher.persisted?).to eq(false)
        expect(publisher.changed?).to eq(false)
      end
    end

    context 'already persisted' do
      def publishers_api
        Mock5.mock('http://example.com:1234') do

          get '/v2/servers/_defaultServer_/publishers' do
            status 200
            headers 'Content-Type' => 'application/json'
            JSON.generate({
              serverName: '_defaultServer_',
              publishers: [{ name: 'name' }]
            })
          end

          delete '/v2/servers/_defaultServer_/publishers/name' do
            halt 204
          end

        end
      end

      it 'deletes publisher' do
        Mock5.with_mounted publishers_api do
          publisher = client.publishers.all.first
          expect(publisher.persisted?).to eq(true)
          expect(publisher.changed?).to eq(false)
          publisher.destroy
          expect(publisher.persisted?).to eq(false)
          expect(publisher.changed?).to eq(false)
        end
      end

    end
  end
end
