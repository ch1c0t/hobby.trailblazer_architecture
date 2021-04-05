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

        initial_id = response['id']
        response = @rpc['Clients::Update', id: initial_id, name: 'Robert']
        update_id = response['id']

        response = @rpc['Clients::Read', id: initial_id]
        expect(response['id']).to eq initial_id
        expect(response['id']).to eq update_id
        expect(response['name']).to eq 'Robert'
      end
    end
  end
end
