require_relative '../lib/redis_dbs'

ROOT_ID = 'root_id'

SESSIONS.set 'root token', ROOT_ID
CAPABILITIES.sadd "#{ROOT_ID}.Clients",  ['Create', 'Read', 'Update', 'Delete']
CAPABILITIES.sadd "#{ROOT_ID}.Projects", ['Create', 'Read', 'Update', 'Delete']
