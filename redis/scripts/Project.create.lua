local input = cmsgpack.unpack(ARGV[1])

if not input.name then
  error("This should never happen. No 'name' was passed.")
end

if not input.status then
  error("This should never happen. No 'status' was passed.")
end

local id = redis.call("INCR", "Project.last_id")
if redis.call("SISMEMBER", "Projects.ids", id) == 1 then
  error("This should never happen. A project with such id already exists.")
end
redis.call("SADD", "Project.ids", id)


redis.call("SET", "Project" .. id .. ".name", input.name)
redis.call("SET", "Project" .. id .. ".status", input.status)
if input.client_id then
  redis.call("SET", "Project" .. id .. ".client_id", input.client_id)
end
if input.client then
  -- This is almost a copy of Client.create.lua.
  --
  -- There is a way to call a Redis script from a Redis script, but it is not a public API:
  -- https://stackoverflow.com/questions/24191662/how-do-i-call-a-script-from-a-script-in-redis/24194056#24194056
  -- https://github.com/josiahcarlson/lua-call/blob/master/METHOD.txt
  --
  -- I am thinking of a Ruby DSL for generating Lua scripts for Redis.
  if not input.client.name then
    error("This should never happen. No 'name' was passed.")
  end

  local client_id = redis.call("INCR", "Client.last_id")
  if redis.call("SISMEMBER", "Cliend.ids", client_id) == 1 then
    error("This should never happen. A client with such id already exists.")
  end
  redis.call("SADD", "Client.ids", client_id)

  redis.call("SET", "Client" .. client_id .. ".name", input.client.name)
  redis.call("SET", "Project" .. id .. ".client_id", client_id)
end


local output = {
  id = id,
  name = input.name,
}

return cmsgpack.pack(output)
