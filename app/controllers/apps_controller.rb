# frozen_string_literal: true

# Handles creating apps which are owned by a team
class AppsController < ApplicationController
  before_action :authorize_session!
  before_action :get_team
  before_action :set_app, only: %i[show edit update destroy]

  # GET /apps or /apps.json
  def index
    @apps = @team.apps
  end

  # GET /apps/1 or /apps/1.json
  def show; end

  # GET /apps/new
  def new
    @app = @team.apps.build
  end

  # GET /apps/1/edit
  def edit; end

  # POST /apps or /apps.json
  def create
    @app = @team.apps.build(app_params)

    respond_to do |format|
      if @app.save
        format.html { redirect_to team_apps_url(@team), notice: 'App was successfully created.' }
        format.json { render :show, status: :created, location: @app }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @app.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /apps/1 or /apps/1.json
  def update
    respond_to do |format|
      if @app.update(app_params)
        format.html { redirect_to team_app_url(@team), notice: 'App was successfully updated.' }
        format.json { render :show, status: :ok, location: @app }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @app.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /apps/1 or /apps/1.json
  def destroy
    @app.destroy

    respond_to do |format|
      format.html { redirect_to team_apps_url(@team), notice: 'App was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def get_team
    @team = Team.find(params[:team_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_app
    @app = @team.apps.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def app_params
    params.require(:app).permit(:name, :team_id)
  end
end
