module Projects
  class Create < Act
    Status = Dry.Types::String.enum('done', 'ongoing', 'paused')
    Input = Dry::Schema.JSON do
      required(:name).filled(:string)
      required(:status).filled(Status)
      optional(:client_id).filled(:string) # to map to an existing client
      optional(:client).hash do            # to create a new client
        required(:name).filled(:string)
      end
    end

    step :output

    def output (ctx, user:, **)
      input = ctx[:input]
      client_id = input.delete :client_id
      client = input.delete :client

      input[:client] = if client_id && client
        fail 'Both options were passed, which is not allowed.'
      elsif client_id
        Client.new client_id
      elsif client
        Client.new Clients::Create.(user: user, input: client)[:output][:id]
      else
        fail 'No project can exist without a client.'
      end

      project = Project.create input
      ctx[:output] = {
        id: project.id,
        name: project.name,
      }
    end
  end
end
