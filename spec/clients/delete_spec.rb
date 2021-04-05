describe 'Clients' do
  describe 'Create' do
    context 'root client' do
      before do
        @rpc = RPCClient.new 'http://127.0.0.1:8080', token: 'root token'
      end

      it do
        response = @rpc['Clients::Create', name: 'Bob']
        expect(response['id']).to be_a String
        expect(response['name']).to eq 'Bob'

        id = response['id']

        response = @rpc['Clients::Read', id: id]
        expect(response['name']).to eq 'Bob'

        @rpc['Clients::Delete', id: id]
        response = @rpc['Clients::Read', id: id]
        expect(response['error']).to eq 'no client has such id'
      end
    end
  end
end
