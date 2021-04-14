module Projects
  class Create < Act
    Status = Dry.Types::String.enum('done', 'ongoing', 'paused')
    Input = Dry::Schema.JSON do
      required(:name).filled(:string)
      required(:status).filled(Status)
      optional(:client_id).filled(:integer) # to map to an existing client
      optional(:client).hash do            # to create a new client
        required(:name).filled(:string)
      end
    end

    step :output

    def output (ctx, user:, **)
      input = ctx[:input]

      if input[:client_id] && input[:client]
        fail "You can pass either 'client_id' or 'client', but not both."
      end

      unless input[:client_id] || input[:client]
        fail 'No project can exist without a client.'
      end

      ctx[:output] = RedisCall['Project.create', input]
    end
  end
end
