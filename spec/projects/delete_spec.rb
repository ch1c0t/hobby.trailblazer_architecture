describe 'Clients' do
  describe 'Create' do
    context 'root client' do
      before do
        @rpc = RPCClient.new 'http://127.0.0.1:8081', token: 'root token'
      end

      it do
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

        @rpc['Projects::Delete', id: id]
        response = @rpc['Projects::Read', id: id]
        expect(response['error']).to eq 'no project has such id'
      end
    end
  end
end
