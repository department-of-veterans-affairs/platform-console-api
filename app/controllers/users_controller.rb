# frozen_string_literal: true

# Handles creating users which will own apps
class UsersController < ApplicationController
  before_action :authorize_session!
  before_action :set_user, only: %i[show edit update]
  before_action :authorize_user!

  # GET /users/1/show
  def show; end

  # GET /users/1/edit
  def edit
    @github_user = @user.github_user
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to edit_user_url(@user), notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:name, :email)
  end

  def authorize_user!
    return if @user == current_user

    respond_to do |format|
      flash[:error] = 'Unauthorized'
      format.html { redirect_to root_path }
    end
  end
end
