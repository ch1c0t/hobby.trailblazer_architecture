module Clients
  class Update < Act
    Input = Dry::Schema.JSON do
      required(:id).filled(:integer)
      required(:name).filled(:string)
    end

    step :output

    def output (ctx, **)
      ctx[:output] = RedisCall['Client.update', ctx[:input]]
    end
  end
end
