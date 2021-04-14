require_relative '../lib/all'

require_relative 'projects/create'
require_relative 'projects/read'
require_relative 'projects/update'
require_relative 'projects/delete'

Run[RPC.new, port: 8081]
