module Clients
  class Create < Act
    Input = Dry::Schema.JSON do
      required(:name).filled(:string)
    end

    step :output

    def output (ctx, **)
      client = Client.create ctx[:input]
      ctx[:output] = {
        id: client.id,
        name: client.name,
      }
    end
  end
end
