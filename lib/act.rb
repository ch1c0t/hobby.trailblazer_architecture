require 'dry/schema'
require 'trailblazer/operation'

class Act < Trailblazer::Operation
  step :authorize
  step :validate

  def authorize (ctx, user:, **)
    user.has_right_to? self.class
  end

  def validate (ctx, input:, **)
    schema = self.class::Input.(input)
    fail unless schema.success?
    ctx[:input] = schema.to_h
  end
end
