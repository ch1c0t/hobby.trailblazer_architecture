local input = cmsgpack.unpack(ARGV[1])

if not input.name then
  error("This should never happen. No 'name' was passed.")
end


local id = redis.call("INCR", "Client.last_id")
if redis.call("SISMEMBER", "Cliend.ids", id) == 1 then
  error("This should never happen. A client with such id already exists.")
end
redis.call("SADD", "Client.ids", id)


redis.call("SET", "Client" .. id .. ".name", input.name)

local output = {
  id = id,
  name = input.name,
}

return cmsgpack.pack(output)
