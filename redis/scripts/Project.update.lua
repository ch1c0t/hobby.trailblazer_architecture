local input = cmsgpack.unpack(ARGV[1])

if redis.call("SISMEMBER", "Project.ids", input.id) == 1 then
  if input.name then
    redis.call("SET", "Project" .. input.id .. ".name", input.name)
  end

  if input.status then
    redis.call("SET", "Project" .. input.id .. ".status", input.status)
  end

  if input.client_id then
    if redis.call("SISMEMBER", "Client.ids", input.client_id) == 1 then
      redis.call("SET", "Project" .. ".client_it", input.client_id)
    else
      error("No client with id " .. input.client_id)
    end
  end

  local output = {
    id = input.id,
    name = redis.call("GET", "Project" .. input.id .. ".name"),
  }

  return cmsgpack.pack(output)
else
  return nil
end
