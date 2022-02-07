# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Authenticatable
  include Pagy::Backend
end
