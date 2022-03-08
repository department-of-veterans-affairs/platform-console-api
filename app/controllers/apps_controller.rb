# frozen_string_literal: true

# Handles creating apps which are owned by a team
class AppsController < ApplicationController
  before_action :authorize_session!
  before_action :set_team
  before_action :set_app, only: %i[show edit update destroy]
  before_action :set_github_info, :set_github_stats, only: :show

  # GET /apps or /apps.json
  def index
    @apps = @team.apps
    @pagy, @apps = pagy @apps
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
        format.html { redirect_to team_app_url(@team, @app), notice: 'App was successfully created.' }
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
        format.html { redirect_to team_app_url(@team, @app), notice: 'App was successfully updated.' }
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
      format.html { redirect_to team_url(@team), notice: 'App was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_team
    @team = Team.find(params[:team_id])
  end

  # Find the team app
  def set_app
    @app = @team.apps.find(params[:id])
    @app.current_user = current_user
  end

  # Set the current github repository and get the latest releases for it
  def set_github_info
    return if @app.github_repo.blank?

    @github_repository = @app.repository(current_user.github_token)
    @releases = @github_repository.octokit_client.releases(@app.github_repo)
  end

  # Set various github stats for the overview
  def set_github_stats
    return if @app.github_repo.blank?

    variables = { owner: @github_repository.github.owner.login, name: @github_repository.github.name }
    context = { access_token: current_user.github_token }

    @github_stats = Github::GraphQL::Client.query(
      Github::GraphQL::GithubInfoQuery, variables: variables, context: context
    ).data.repo
  end

  # Only allow a list of trusted parameters through.
  def app_params
    params.require(:app).permit(:name, :team_id, :github_repo)
  end
end
