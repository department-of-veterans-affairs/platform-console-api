# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/teams', type: :request do
  fixtures :users, :teams

  before(:each) do
    @user = users(:john)
    setup_omniauth_mock(@user)
    VCR.insert_cassette('rswag/teams')
  end

  after(:each) do
    VCR.eject_cassette
  end

  path '/v1/teams' do
    get('list teams') do
      tags 'Teams'
      response(200, 'OK') do
        include_context 'run request test'
      end
    end

    post('create team') do
      tags 'Teams'
      consumes 'application/json'
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          team: {
            type: :object,
            properties: {
              name: { type: :string }
            }
          },
          required: %w[name]
        },
        required: %w[team]
      }

      response(201, 'Created') do
        let(:params) { { team: { name: teams(:one).name } } }
        include_context 'run request test'
      end

      response(422, 'Unprocessable Entity') do
        let(:params) { { team: { name: nil } } }
        include_context 'run request test'
      end
    end
  end

  path '/v1/teams/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'id'

    let(:id) { teams(:one).id }

    get('show team') do
      tags 'Teams'
      response(200, 'OK') do
        include_context 'run request test'
      end
    end

    patch('update team') do
      tags 'Teams'
      consumes 'application/json'
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          team: {
            type: :object,
            properties: {
              name: { type: :string }
            }
          },
          required: %w[name]
        },
        required: %w[team]
      }

      response(200, 'OK') do
        let(:params) { { team: { name: teams(:two).name } } }
        include_context 'run request test'
      end

      response(422, 'Unprocessable Entity') do
        let(:params) { { team: { name: nil } } }
        include_context 'run request test'
      end
    end

    delete('delete team') do
      tags 'Teams'
      response(204, 'No Content') do
        run_test!
      end
    end
  end
end
