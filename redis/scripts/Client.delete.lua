local input = cmsgpack.unpack(ARGV[1])

if redis.call("SISMEMBER", "Client.ids", input.id) == 1 then
  redis.call("DEL", "Client" .. input.id .. ".name")
  redis.call("SREM", "Client.ids", input.id)

  local output = {
    id = input.id,
  }

  return cmsgpack.pack(output)
else
  return nil
end
