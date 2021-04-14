require_relative '../helper'

describe 'Clients' do
  describe 'Create' do
    context 'root client' do
      before do
        headers = {
          'Content-Type'  => 'application/json',
          'Authorization' => 'root token',
        }
        @excon = Excon.new 'http://127.0.0.1:8080', headers: headers
      end

      it do
        body = {
          ns: 'Clients',
          fn: 'Create',
          in: {
            name: 'Alice'
          }
        }
        response = @excon.post body: body.to_json
        
        body = JSON.parse response.body
        expect(body['name']).to eq 'Alice'

        read_body = {
          ns: 'Clients',
          fn: 'Read',
          in: {
            id: body['id']
          }
        }

        response = @excon.post body: read_body.to_json
        read_body = JSON.parse response.body
        expect(read_body['id']).to eq body['id']
        expect(read_body['name']).to eq body['name']
      end

      it do
        rpc = RPCClient.new 'http://127.0.0.1:8080', token: 'root token'
        response = rpc['Clients::Create', name: 'Bob']
        expect(response['id']).to be_a Integer
        expect(response['name']).to eq 'Bob'
      end
    end
  end
end
