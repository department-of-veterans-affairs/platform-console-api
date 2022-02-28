# frozen_string_literal: true

module Github
  class OauthController < ApplicationController
    before_action :authorize_session!

    def callback
      token = Octokit.exchange_code_for_token(params[:code])
      if current_user.update(github_token: token)
      end
    end
  end
end
