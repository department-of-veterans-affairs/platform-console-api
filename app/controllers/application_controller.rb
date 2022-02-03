# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Authenticatable
  include Pundit
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  include Pagy::Backend
end
