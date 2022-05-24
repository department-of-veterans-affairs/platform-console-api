# frozen_string_literal: true

# For serializer helpers
module SerializerHelper
  def team_id_from_app_id(app_id)
    return if app_id.nil?

    App.find_by(id: app_id)&.team_id
  end

  def api_path
    "#{ENV['BASE_URL']}/api/v1"
  end
end
