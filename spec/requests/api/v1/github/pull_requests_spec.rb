# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe Api::V1::Github::PullRequestsController, type: :request do
  fixtures :users, :teams, :apps
  path '/v1/teams/{team_id}/apps/{app_id}/pull_requests' do
    parameter name: 'team_id', in: :path, type: :int, description: 'team_id'
    parameter name: 'app_id', in: :path, type: :int, description: 'app_id'

    before(:each) do
      @user = users(:john)
      setup_omniauth_mock(@user)
      VCR.insert_cassette('rswag/pull_requests')
    end

    after(:each) do
      VCR.eject_cassette
    end

    let(:team_id) { teams(:three).id }
    let(:app_id) { apps(:four).id }

    get 'list pull_requests' do
      response(200, 'successful') do
        include_context 'run request test'
      end
    end
  end
end
