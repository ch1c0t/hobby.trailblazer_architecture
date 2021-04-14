module Clients
  class Create < Act
    Input = Dry::Schema.JSON do
      required(:name).filled(:string)
    end

    step :output

    def output (ctx, **)
      ctx[:output] = RedisCall['Client.create', ctx[:input]]
    end
  end
end
