require 'json'

require 'ap'
require 'excon'

require_relative 'rpc_client'

RSpec.configure do |config|
  config.before :suite do
    require_relative 'seed_users'
  end
end
