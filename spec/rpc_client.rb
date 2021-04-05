require 'json'
require 'excon'

class RPCClient
  def initialize url, token:
    headers = {
      'Content-Type'  => 'application/json',
      'Authorization' => token,
    }
    @excon = Excon.new url, headers: headers
  end

  def [] constant_name, input
    *head, function = constant_name.split '::'
    namespace = head.join '::'

    request = {
      ns: namespace,
      fn: function,
      in: input,
    }
    response = @excon.post body: request.to_json
    JSON.parse response.body
  end
end
