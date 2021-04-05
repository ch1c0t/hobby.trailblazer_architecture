require 'hobby'
require 'hobby/json'
require 'hobby/auth'
require 'dry/schema'

require_relative './roles/client'

class RPC
  include Hobby
  include JSON
  include Auth[Client]

  Request = Dry::Schema.JSON do
    required(:ns).filled(:string)
    required(:fn).filled(:string)
    required(:in)
  end

  Client post {
    begin 
      request = Request.(json)
      fail unless request.success?

      user[request.to_h].to_h
    rescue
      response.status = 400
    end
  }
end
