# frozen_string_literal: true

# Handles creating apps which are owned by a team
class AppsController < ApplicationController
  before_action :authorize_session!
  before_action :set_team
  before_action :set_app, only: %i[show edit update destroy]
  before_action :set_github_info, only: :show

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

  def create_deploy_pr
    respond_to do |format|
      if @github_repository.dispatch_create_pr_workflow
        format.html do
          redirect_to team_app_deploys_path(@team, @app),
                      notice: 'PR has been queued for creation.'
        end
        format.json { render json: true, status: :ok }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: false, status: :unprocessable_entity }
      end
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

  # Query to get various stats for the app's github repository
  GithubInfoQuery = GitHub::Client.parse <<~'GRAPHQL'
    query($owner: String!, $name: String!) {
      repo: repository(owner: $owner, name: $name) {
        open_issues: issues(states: OPEN) {
        totalCount
        }
        branches: refs(first: 0, refPrefix: "refs/heads/") {
          totalCount
        }
        pull_requests: pullRequests(states:OPEN) {
          totalCount
        }
        releases: releases {
          totalCount
        }
        latest_release: latestRelease{
          name
        }
      }
    }
  GRAPHQL
  # Set the current github repository and provide stats for the overview
  def set_github_info
    return if @app.github_repo.blank?

    @github_repository = Github::Repository.new(@app.github_repo)
    @github_stats = GitHub::Client.query(GithubInfoQuery,
                                         variables: { owner: @github_repository.github.owner.login,
                                                      name: @github_repository.github.name }).data.repo
    @releases = @github_repository.octokit_client.releases(@app.github_repo)
  end

  # Only allow a list of trusted parameters through.
  def app_params
    params.require(:app).permit(:name, :team_id, :github_repo)
  end
end
