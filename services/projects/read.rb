module Projects
  class Read < Act
    Input = Dry::Schema.JSON do
      required(:id).filled(:integer)
    end

    step :output

    def output (ctx, **)
      project = RedisCall['Project.read', ctx[:input]]
      ctx[:output] = if project
                       project.to_h
                     else
                       { error: 'no project has such id' }
                     end
    end
  end
end
