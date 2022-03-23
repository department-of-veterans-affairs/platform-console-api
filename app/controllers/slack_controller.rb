# frozen_string_literal: true

# Handles slack client interactions
class SlackController < ApplicationController
  before_action :authorize_session!
  before_action :set_slack_client

  # GET /slack_messages or /slack_messages.json
  def index
    @channels = @slack_client.conversations_list.channels
    @channel = params[:channel_id] ? @channels.detect { |c| c.id == params[:channel_id] } : @channels[0]
    @messages = @slack_client.conversations_history(channel: @channel.id)["messages"]
    @users = @slack_client.users_list["members"]
  end

  # GET /slack_messages
  def show

  end

  # GET /slack_messages
  def new; end

  # GET /slack_messages
  def edit; end

  # POST /slack_messages
  def create
    @slack_client.chat_postMessage(channel: '#' + params[:channel], text: params[:message], as_user: true)
    redirect_back(fallback_location: root_path)
  end

  # PATCH/PUT /slack_messages/1
  def update; end

  # DELETE /slack_messages/1
  def destroy
    #@slack_client.chat_delete(channel: @channel.id, ts: "1647898408.598249")
  end

  def channel_users
    @users = @slack_client.users_list["members"]
    render json: @users.detect { |u| u.name.include?("rcc") || u.display_name.include?("rcc") }
  end

  private

  def set_slack_client
    @slack_client = Slack::Web::Client.new(token: session[:slack_token])
  end
end
