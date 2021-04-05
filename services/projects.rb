require_relative '../lib/all'

require_relative 'projects/create'
require_relative 'projects/read'
require_relative 'projects/update'
require_relative 'projects/delete'
require_relative 'clients/create'
require_relative 'clients/read'
require_relative 'clients/update'
require_relative 'clients/delete'

Run[RPC.new, port: 8081]
