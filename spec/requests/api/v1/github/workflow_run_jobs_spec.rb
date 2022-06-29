# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/github/workflow_run_jobs', type: :request do
  fixtures :users, :teams, :apps

  before(:each) do
    @user = users(:john)
    setup_omniauth_mock(@user)
    VCR.insert_cassette('rswag/workflow_run_jobs', record: :new_episodes)
  end

  after(:each) do
    VCR.eject_cassette
  end

  path '/v1/teams/{team_id}/apps/{app_id}/workflow_run_jobs/{id}' do
    parameter name: 'team_id', in: :path, type: :int, description: 'team_id'
    parameter name: 'app_id', in: :path, type: :int, description: 'app_id'
    parameter name: 'id', in: :path, type: :int, description: 'id'

    let(:team_id) { teams(:three).id }
    let(:app_id) { apps(:four).id }
    let(:id) { 7_115_360_258 }

    get('show workflow_run_job') do
      tags 'Workflow Run Jobs'
      response(200, 'OK') do
        include_context 'run request test'
      end
    end
  end
end
