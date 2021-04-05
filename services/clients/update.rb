module Clients
  class Update < Act
    Input = Dry::Schema.JSON do
      required(:id).filled(:string)
      required(:name).filled(:string)
    end

    step :output

    def output (ctx, **)
      input = ctx[:input]
      id = input.delete :id

      client = Client.find_by_id id
      client.update input

      ctx[:output] = {
        id: client.id,
        name: client.name,
      }
    end
  end
end
