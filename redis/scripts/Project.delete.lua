local input = cmsgpack.unpack(ARGV[1])

if redis.call("SISMEMBER", "Project.ids", input.id) == 1 then
  redis.call("DEL", "Project" .. input.id .. ".name")
  redis.call("DEL", "Project" .. input.id .. ".status")
  redis.call("DEL", "Project" .. input.id .. ".client_id")
  redis.call("SREM", "Project.ids", input.id)

  local output = {
    id = input.id,
  }

  return cmsgpack.pack(output)
else
  return nil
end
