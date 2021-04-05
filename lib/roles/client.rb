require_relative '../redis_dbs'

class Client
  # It is used for authentication and basic role-based authorization.
  # `Client` is the only role at the moment, but it might change.
  # https://github.com/ch1c0t/hobby-auth
  def self.find_by_token token
    client_id = SESSIONS.get token
    new client_id if client_id
  end

  def initialize id
    @id = id
  end

  def [] data
    namespace, function = data[:ns], data[:fn]

    if can? namespace, function
      args = { input: data[:in], user: self }
      result = Object.const_get("::#{namespace}::#{function}").(args)
      result.success? ? result[:output] : fail
    else
      { error: "unauthorized to call #{namespace}::#{function}" }
    end
  end

  # A second-level authorization, which is capability-based.
  # Check if a client can call a function in a namespace.
  def can? namespace, function
    key = "#{@id}.#{namespace}"
    CAPABILITIES.sismember key, function
  end

  def has_right_to? constant
    *head, function = constant.name.split '::'
    namespace = head.join '::'

    can? namespace, function
  end
end
