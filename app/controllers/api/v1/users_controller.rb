# frozen_string_literal: true

module Api
  module V1
    # Handles creating users which will own apps
    class UsersController < ApplicationController
      before_action :set_user, only: %i[show update]

      # GET /v1/users/:id
      def show
        @user = User.find_by(id: params[:id])
        render json: ::UserSerializer.new(@user).serializable_hash
      end

      # PATCH /v1/users/:id
      def update
        if @user.update(user_params)
          render json: ::UserSerializer.new(@user), status: :ok
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      private

      def set_user
        @user = User.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def user_params
        params.require(:user).permit(:name, :email)
      end
    end
  end
end
