# frozen_string_literal: true

# Allows calling auth methods in Routes (such as current_user)
class AuthenticatableConstraint
  include Authenticatable

  attr_accessor :request

  def initialize(request)
    @request = request
  end

  def cookies
    request.cookie_jar
  end
end
