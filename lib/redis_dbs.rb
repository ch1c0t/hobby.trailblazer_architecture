require 'redis'

SESSIONS = Redis.new
CAPABILITIES = Redis.new port: 6380
STORE = Redis.new port: 6381
