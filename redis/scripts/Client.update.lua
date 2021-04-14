local input = cmsgpack.unpack(ARGV[1])

if redis.call("SISMEMBER", "Client.ids", input.id) == 1 then
  if input.name then
    redis.call("SET", "Client" .. input.id .. ".name", input.name)
  end

  local output = {
    id = input.id,
    name = redis.call("GET", "Client" .. input.id .. ".name"),
  }

  return cmsgpack.pack(output)
else
  return nil
end
