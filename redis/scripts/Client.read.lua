local input = cmsgpack.unpack(ARGV[1])

if redis.call("SISMEMBER", "Client.ids", input.id) == 1 then
  local output = {
    id = input.id,
    name = redis.call("GET", "Client" .. input.id .. ".name"),
  }

  return cmsgpack.pack(output)
else
  return nil
end
