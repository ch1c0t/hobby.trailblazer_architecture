module Projects
  class Update < Act
    Status = Dry.Types::String.enum('done', 'ongoing', 'paused')
    Input = Dry::Schema.JSON do
      required(:id).filled(:integer)
      optional(:name).filled(:string)
      optional(:status).filled(Status)
      optional(:client_id).filled(:integer)
    end

    step :output

    def output (ctx, user:, **)
      ctx[:output] = RedisCall['Project.update', ctx[:input]]
    end
  end
end
