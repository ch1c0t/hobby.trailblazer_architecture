module Clients
  class Delete < Act
    Input = Dry::Schema.JSON do
      required(:id).filled(:string)
    end

    step :output

    def output (ctx, **)
      client = Client.find_by_id ctx[:input][:id]
      client.delete

      ctx[:output] = {
        id: client.id
      }
    end
  end
end
