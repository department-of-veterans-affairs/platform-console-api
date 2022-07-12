# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/github/workflow_runs', type: :request do
  fixtures :users, :teams, :apps

  before(:each) do
    @user = users(:john)
    setup_omniauth_mock(@user)
    VCR.insert_cassette('rswag/workflow_runs', record: :new_episodes)
  end

  after(:each) do
    VCR.eject_cassette
  end

  path '/v1/teams/{team_id}/apps/{app_id}/workflow_runs' do
    parameter name: 'team_id', in: :path, type: :integer, description: 'team_id'
    parameter name: 'app_id', in: :path, type: :integer, description: 'app_id'

    let(:team_id) { teams(:three).id }
    let(:app_id) { apps(:four).id }

    get('list workflow_runs') do
      tags 'Workflow Runs'
      response(200, 'OK') do
        include_context 'run request test'
      end
    end

    post('create workflow_run') do
      tags 'Workflow Runs'
      response(200, 'OK') do
        include_context 'run request test'
      end
    end
  end

  path '/v1/teams/{team_id}/apps/{app_id}/workflow_runs/{id}' do
    parameter name: 'team_id', in: :path, type: :integer, description: 'team_id'
    parameter name: 'app_id', in: :path, type: :integer, description: 'app_id'
    parameter name: 'id', in: :path, type: :integer, description: 'id'

    let(:team_id) { teams(:three).id }
    let(:app_id) { apps(:four).id }
    let(:id) { 2_471_421_620 }

    get('show workflow_run') do
      tags 'Workflow Runs'
      response(200, 'OK') do
        include_context 'run request test'
      end
    end

    patch('rerun workflow_run') do
      tags 'Workflow Runs'
      response(201, 'Created') do
        include_context 'run request test'
      end

      response(422, 'Unprocessable Entity') do
        tags 'Workflow Runs'
        let(:id) { 'invalid_id' }
        include_context 'run request test'
      end
    end
  end
end
