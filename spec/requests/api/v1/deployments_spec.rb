# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/deployments', type: :request do
  fixtures :users, :teams, :apps, :deployments

  before(:each) do
    @user = users(:john)
    setup_omniauth_mock(@user)
    @api_key = @user.api_keys.first.token
    VCR.insert_cassette('rswag/deployments')
  end

  after(:each) do
    VCR.eject_cassette
  end

  path '/v1/teams/{team_id}/apps/{app_id}/deployments' do
    parameter name: 'team_id', in: :path, type: :integer, description: 'team_id'
    parameter name: 'app_id', in: :path, type: :integer, description: 'app_id'

    let(:team_id) { teams(:two).id }
    let(:app_id) { apps(:two).id }
    let(:Authorization) { "Bearer #{@api_key}" }

    get('list deployments') do
      tags 'Deployments'
      consumes 'application/json'
      security [Bearer: []]
      response(200, 'OK') do
        include_context 'run request test'
      end
    end

    post('create deployment') do
      tags 'Deployments'
      consumes 'application/json'
      security [Bearer: []]
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          deployment: {
            type: :object,
            properties: {
              name: { type: :string },
              app_id: { type: :integer }
            }
          }
        },
        required: %w[deployment]
      }

      response(201, 'Created') do
        let(:params) { { deployment: { name: deployments(:one).name, app_id: app_id } } }
        include_context 'run request test'
      end

      response(422, 'Unprocessable Entity') do
        let(:params) { { deployment: { name: nil, app_id: nil } } }
        include_context 'run request test'
      end
    end
  end

  path '/v1/teams/{team_id}/apps/{app_id}/deployments/{id}' do
    parameter name: 'team_id', in: :path, type: :integer, description: 'team_id'
    parameter name: 'app_id', in: :path, type: :integer, description: 'app_id'
    parameter name: 'id', in: :path, type: :integer, description: 'id'

    let(:team_id) { teams(:two).id }
    let(:app_id) { apps(:two).id }
    let(:id) { deployments(:one).id }
    let(:Authorization) { "Bearer #{@api_key}" }

    get('show deployment') do
      tags 'Deployments'
      consumes 'application/json'
      security [Bearer: []]
      response(200, 'OK') do
        include_context 'run request test'
      end
    end

    patch('update deployment') do
      tags 'Deployments'
      consumes 'application/json'
      security [Bearer: []]
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          deployment: {
            type: :object,
            properties: {
              name: { type: :string }
            }
          }
        },
        required: %w[deployment]
      }

      response(200, 'OK') do
        let(:params) { { deployment: { name: deployments(:one).name } } }
        include_context 'run request test'
      end

      response(422, 'Unprocessable Entity') do
        let(:params) { { deployment: { name: nil } } }
        include_context 'run request test'
      end
    end

    delete('delete deployment') do
      tags 'Deployments'
      consumes 'application/json'
      security [Bearer: []]
      response(204, 'No Content') do
        run_test!
      end
    end
  end
end
