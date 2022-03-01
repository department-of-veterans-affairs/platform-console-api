# frozen_string_literal: true

module Github
  # Controller handling Github Oauth callbacl=k and revoke
  class OauthController < ApplicationController
    before_action :authorize_session!

    def callback
      token = Octokit.exchange_code_for_token(params[:code]).access_token
      respond_to do |format|
        if token.present? && current_user.update(github_token: token)
          format.html { redirect_to edit_user_path(current_user), notice: 'GitHub account successfully connected.' }
        else
          format.html { redirect_to edit_user_path(current_user), error: 'There was a problem adding your account' }
        end
      end
    end

    def revoke
      respond_to do |format|
        if Octokit.delete_app_authorization(current_user.github_token) && current_user.update(github_token: nil)
          format.html { redirect_to edit_user_path(current_user), notice: 'GitHub account successfully removed.' }
        else
          format.html { redirect_to edit_user_path(current_user), error: 'There was a problem removing your account' }
        end
      end
    end
  end
end
