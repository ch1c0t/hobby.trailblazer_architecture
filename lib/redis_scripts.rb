require 'msgpack'

REDIS_SCRIPTS = {}

class Script
  attr_reader :name, :content, :sha1

  # https://www.rubydoc.info/github/redis/redis-rb/Redis:script
  def initialize file
    @name = File.basename file, '.lua'
    @content = IO.read file
    @sha1 = STORE.script :load, @content
  end
end

Dir['redis/scripts/*.lua'].each do |file|
  script = Script.new file
  REDIS_SCRIPTS[script.name] = script
end

# https://www.rubydoc.info/github/redis/redis-rb/Redis#eval-instance_method
RedisCall = -> name, input do
  begin 
    script = REDIS_SCRIPTS[name]

    output = STORE.evalsha script.sha1, [], [input.to_msgpack]
    MessagePack.unpack output
  rescue => e
    p e
    nil
  end
end
