# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/apps', type: :request do
  fixtures :users, :teams, :apps

  before(:each) do
    @user = users(:john)
    setup_omniauth_mock(@user)
    VCR.insert_cassette('rswag/apps')
  end

  after(:each) do
    VCR.eject_cassette
  end

  path '/v1/teams/{team_id}/apps' do
    parameter name: 'team_id', in: :path, type: :integer, description: 'team_id'
    parameter name: 'id', in: :path, type: :integer, description: 'id'

    let(:team_id) { teams(:three).id }
    let(:id) { apps(:four).id }

    get('list apps') do
      tags 'Apps'
      response(200, 'OK') do
        include_context 'run request test'
      end
    end

    post('create app') do
      tags 'Apps'
      consumes 'application/json'
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          app: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              team_id: { type: :integer }
            }
          },
          required: %w[name team_id]
        },
        required: %w[app]
      }

      response(201, 'Created') do
        let(:params) { { app: { name: apps(:four).name, team_id: team_id } } }
        include_context 'run request test'
      end

      response(422, 'Unprocessable Entity') do
        let(:params) { { app: { name: nil, team_id: nil } } }
        include_context 'run request test'
      end
    end
  end

  path '/v1/teams/{team_id}/apps/{id}' do
    parameter name: 'team_id', in: :path, type: :integer, description: 'team_id'
    parameter name: 'id', in: :path, type: :integer, description: 'id'

    let(:team_id) { teams(:three).id }
    let(:id) { apps(:four).id }

    get('show app') do
      tags 'Apps'
      response(200, 'OK') do
        include_context 'run request test'
      end
    end

    patch('update app') do
      tags 'Apps'
      consumes 'application/json'
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          app: {
            type: :object,
            properties: {
              name: { type: :string }
            }
          },
          required: %w[name]
        },
        required: %w[app]
      }

      response(200, 'OK') do
        let(:params) { { app: { name: 'App1 Updated' } } }
        include_context 'run request test'
      end

      response(422, 'Unprocessable Entity') do
        let(:params) { { app: { name: nil } } }
        include_context 'run request test'
      end
    end

    delete('delete app') do
      tags 'Apps'
      response(204, 'No Content') do
        run_test!
      end
    end
  end
end
