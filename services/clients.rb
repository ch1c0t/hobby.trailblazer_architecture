require_relative '../lib/all'

require_relative 'clients/create'
require_relative 'clients/read'
require_relative 'clients/update'
require_relative 'clients/delete'

Run[RPC.new, port: 8080]
