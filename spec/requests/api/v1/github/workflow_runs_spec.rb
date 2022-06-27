# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/github/workflow_runs', type: :request do
  fixtures :users, :teams, :apps
  path '/v1/teams/{team_id}/apps/{app_id}/workflow_runs' do
    parameter name: 'team_id', in: :path, type: :int, description: 'team_id'
    parameter name: 'app_id', in: :path, type: :int, description: 'app_id'

    before(:each) do
      @user = users(:john)
      setup_omniauth_mock(@user)
      VCR.insert_cassette('rswag/workflow_runs', record: :new_episodes)
    end

    after(:each) do
      VCR.eject_cassette
    end

    get('lists workflow_runs') do
      response(200, 'successful') do
        let(:team_id) { teams(:three).id }
        let(:app_id) { apps(:four).id }

        include_context 'run request test'
      end
    end

    post('creates workflow_run') do
      response(200, 'successful') do
        let(:team_id) { teams(:three).id }
        let(:app_id) { apps(:four).id }

        include_context 'run request test'
      end
    end
  end

  path '/v1/teams/{team_id}/apps/{app_id}/workflow_runs/{id}' do
    parameter name: 'team_id', in: :path, type: :int, description: 'team_id'
    parameter name: 'app_id', in: :path, type: :int, description: 'app_id'
    parameter name: 'id', in: :path, type: :int, description: 'id'

    before(:each) do
      @user = users(:john)
      setup_omniauth_mock(@user)
      VCR.insert_cassette('rswag/workflow_runs', record: :new_episodes)
    end

    after(:each) do
      VCR.eject_cassette
    end

    get('show workflow_run') do
      response(200, 'successful') do
        let(:team_id) { teams(:three).id }
        let(:app_id) { apps(:four).id }
        let(:id) { 2_471_421_620 }

        include_context 'run request test'
      end
    end

    patch('rerun workflow_run') do
      response(201, 'created') do
        let(:team_id) { teams(:three).id }
        let(:app_id) { apps(:four).id }
        let(:id) { 2_471_421_620 }

        include_context 'run request test'
      end
    end
  end
end
