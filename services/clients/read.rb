module Clients
  class Read < Act
    Input = Dry::Schema.JSON do
      required(:id).filled(:string)
    end

    step :output

    def output (ctx, **)
      client = Client.find_by_id ctx[:input][:id]
      ctx[:output] = if client
                       client.to_h
                     else
                       { error: 'no client has such id' }
                     end
    end
  end
end
