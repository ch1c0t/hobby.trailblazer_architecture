module Projects
  class Delete < Act
    Input = Dry::Schema.JSON do
      required(:id).filled(:string)
    end

    step :output

    def output (ctx, **)
      project = Project.find_by_id ctx[:input][:id]
      project.delete

      ctx[:output] = {
        id: project.id
      }
    end
  end
end
