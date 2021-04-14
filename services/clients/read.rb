module Clients
  class Read < Act
    Input = Dry::Schema.JSON do
      required(:id).filled(:integer)
    end

    step :output

    def output (ctx, **)
      client = RedisCall['Client.read', ctx[:input]]
      p "The client is:"
      p client
      ctx[:output] = if client
                       client.to_h
                     else
                       { error: 'no client has such id' }
                     end
    end
  end
end
