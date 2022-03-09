# frozen_string_literal: true

# Save sensitive session token for API calls
class ConnectedApp < ApplicationRecord
  belongs_to :app
  belongs_to :user
  encrypts :token
  has_paper_trail

  def token_invalid?
    begin
      decoded_token = JWT.decode(token, nil, false)
    rescue StandardError
      return true
    end

    decoded_token_info = decoded_token[0]

    if decoded_token_info.keys.include?('exp')
      expiration = Time.zone.at(decoded_token_info['exp'])
      (expiration + 24.hours) < DateTime.now # token has expired
    else
      false
    end
  end
end
