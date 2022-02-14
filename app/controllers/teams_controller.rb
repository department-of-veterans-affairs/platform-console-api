# frozen_string_literal: true

# Handles creating teams which will own apps
class TeamsController < ApplicationController
  before_action :authorize_session!
  before_action :set_team, only: %i[show edit update destroy]
  before_action :set_teams

  # GET /teams or /teams.json
  def index
    @pagy, @teams = pagy(
      @teams.reorder(sort_column => sort_direction),
      items: params.fetch(:count, 25),
      link_extra: 'data-turbo-action="advance"'
    )
  end

  # GET /teams/1 or /teams/1.json
  def show; end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit; end

  # POST /teams or /teams.json
  def create
    @team = Team.new(team_params)
    @team.owner = current_user

    respond_to do |format|
      if @team.save
        format.html { redirect_to team_url(@team), notice: 'Team was successfully created.' }
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1 or /teams/1.json
  def update
    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to team_url(@team), notice: 'Team was successfully updated.' }
        format.json { render :show, status: :ok, location: @team }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1 or /teams/1.json
  def destroy
    @team.destroy

    respond_to do |format|
      format.html { redirect_to teams_url, notice: 'Team was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_team
    @team = Team.find(params[:id])
  end

  def set_teams
    @teams = @team ? @team.teams : current_user.teams
  end

  # Only allow a list of trusted parameters through.
  def team_params
    params.require(:team).permit(:name, :owner_id, :owner_type)
  end

  def sort_column
    %w[name].include?(params[:sort]) ? params[:sort] : 'name'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end
end
