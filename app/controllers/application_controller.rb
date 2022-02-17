# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Authenticatable
  include Pagy::Backend
  before_action :set_paper_trail_whodunnit
end
