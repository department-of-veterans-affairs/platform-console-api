# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/github/deploy_pull_requests', type: :request do
  before(:each) do
    @user = users(:john)
    @api_key = @user.api_keys.first.token
    VCR.insert_cassette('rswag/deploy_pull_requests')
  end

  after(:each) do
    VCR.eject_cassette
  end

  path '/v1/teams/{team_id}/apps/{app_id}/deploy_pull_requests' do
    parameter name: 'team_id', in: :path, type: :integer, description: 'team_id'
    parameter name: 'app_id', in: :path, type: :integer, description: 'app_id'

    let(:team_id) { teams(:three).id }
    let(:app_id) { apps(:four).id }
    let(:Authorization) { "Bearer #{@api_key}" }

    post 'create deploy_pull_request' do
      tags 'Deploy Pull Requests'
      consumes 'application/json'
      security [Bearer: {}]
      response(200, 'OK') do
        include_context 'run request test'
      end
    end
  end
end
