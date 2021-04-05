module Projects
  class Read < Act
    Input = Dry::Schema.JSON do
      required(:id).filled(:string)
    end

    step :output

    def output (ctx, **)
      project = Project.find_by_id ctx[:input][:id]
      ctx[:output] = if project
                       project.to_h
                     else
                       { error: 'no project has such id' }
                     end
    end
  end
end
