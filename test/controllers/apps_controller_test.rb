# frozen_string_literal: true

require 'test_helper'

class AppsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:john)
    post "/login?uid=#{@user.uid}"
    @team = teams(:one)
    @app = apps(:one)
  end

  test 'should get index' do
    get team_apps_url(@team)
    assert_response :success
  end

  test 'should get new' do
    get new_team_app_url(@team)
    assert_response :success
  end

  test 'should create app' do
    assert_difference('App.count') do
      post team_apps_url(@team), params: { app: { name: @app.name, team_id: @team.id } }
    end

    assert_redirected_to team_app_url(@team, App.last)
  end

  test 'should show app' do
    get team_app_url(@team, @app)
    assert_response :success
  end

  test 'should get edit' do
    get edit_team_app_url(@team, @app)
    assert_response :success
  end

  test 'should update app' do
    patch team_app_url(@team, @app), params: { app: { name: 'App1A' } }
    assert_redirected_to team_app_url(@team, @app)
  end

  test 'should destroy app' do
    assert_difference('App.count', -1) do
      delete team_app_url(@team, @app)
    end

    assert_redirected_to team_url(@team)
  end
end
