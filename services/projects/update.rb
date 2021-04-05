module Projects
  class Update < Act
    Status = Dry.Types::String.enum('done', 'ongoing', 'paused')
    Input = Dry::Schema.JSON do
      required(:id).filled(:string)
      optional(:name).filled(:string)
      optional(:status).filled(Status)
      optional(:client_id).filled(:string)
    end

    step :output

    def output (ctx, user:, **)
      input = ctx[:input]
      project = Project.find_by_id input[:id]
      project.update input

      ctx[:output] = {
        id: project.id,
        name: project.name,
      }
    end
  end
end
