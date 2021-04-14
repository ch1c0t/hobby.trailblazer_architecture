module Projects
  class Delete < Act
    Input = Dry::Schema.JSON do
      required(:id).filled(:integer)
    end

    step :output

    def output (ctx, **)
      ctx[:output] = RedisCall['Project.delete', ctx[:input]]
    end
  end
end
