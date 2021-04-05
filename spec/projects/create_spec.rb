require_relative '../helper'

describe 'Clients' do
  describe 'Create' do
    context 'root client' do
      before do
        @rpc = RPCClient.new 'http://127.0.0.1:8081', token: 'root token'
      end

      it 'handles bad requests' do
        response = @rpc['Projects::Create', name: 'Bob']
        expect(response).to eq 400
      end

      it 'creates projects with new clients' do
        input = {
          name: 'Project A',
          status: 'ongoing',
          client: {
            name: 'Newton'
          }
        }
        response = @rpc['Projects::Create', input]
        expect(response['id']).to be_a String
        expect(response['name']).to eq 'Project A'

        id = response['id']
        response = @rpc['Projects::Read', id: id]
        expect(response['name']).to eq 'Project A'
        expect(response['status']).to eq 'ongoing'
        expect(response['client']['name']).to eq 'Newton'
      end

      it 'creates projects with existing clients' do
        id = @rpc['Clients::Create', name: 'Alice']['id']
        expect(id).to be_a String

        input = {
          name: 'Project B',
          status: 'ongoing',
          client_id: id,
        }
        response = @rpc['Projects::Create', input]
        expect(response['id']).to be_a String
        expect(response['name']).to eq 'Project B'

        id = response['id']
        response = @rpc['Projects::Read', id: id]
        expect(response['name']).to eq 'Project B'
        expect(response['status']).to eq 'ongoing'
        expect(response['client']['name']).to eq 'Alice'
      end
    end
  end
end
