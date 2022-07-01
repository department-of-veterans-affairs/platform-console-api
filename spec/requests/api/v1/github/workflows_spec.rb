# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/github/workflows', type: :request do
  fixtures :users, :teams, :apps

  before(:each) do
    @user = users(:john)
    setup_omniauth_mock(@user)
    VCR.insert_cassette('rswag/workflows', record: :new_episodes)
  end

  after(:each) do
    VCR.eject_cassette
  end

  path '/v1/teams/{team_id}/apps/{app_id}/workflows' do
    parameter name: 'team_id', in: :path, type: :integer, description: 'team_id'
    parameter name: 'app_id', in: :path, type: :integer, description: 'app_id'

    let(:team_id) { teams(:three).id }
    let(:app_id) { apps(:four).id }

    get('list workflows') do
      tags 'Workflows'
      response(200, 'OK') do
        include_context 'run request test'
      end
    end
  end

  path '/v1/teams/{team_id}/apps/{app_id}/workflows/{id}' do
    parameter name: 'team_id', in: :path, type: :integer, description: 'team_id'
    parameter name: 'app_id', in: :path, type: :integer, description: 'app_id'
    parameter name: 'id', in: :path, type: :integer, description: 'id'

    let(:team_id) { teams(:three).id }
    let(:app_id) { apps(:four).id }
    let(:id) { 7_426_309 }

    get('show workflow') do
      tags 'Workflows'
      response(200, 'OK') do
        include_context 'run request test'
      end
    end
  end
end
