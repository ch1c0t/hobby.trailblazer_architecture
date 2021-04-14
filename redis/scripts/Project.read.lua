local input = cmsgpack.unpack(ARGV[1])

if redis.call("SISMEMBER", "Project.ids", input.id) == 1 then
  local client_id = redis.call("GET", "Project" .. input.id .. ".client_id")
  local client = {
    id = client_id,
    name = redis.call("GET", "Client" .. client_id .. ".name"),
  }

  local output = {
    id = input.id,
    name = redis.call("GET", "Project" .. input.id .. ".name"),
    status = redis.call("GET", "Project" .. input.id .. ".status"),
    client = client,
  }

  return cmsgpack.pack(output)
else
  return nil
end
