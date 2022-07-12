# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/users', type: :request do
  fixtures :users

  before(:each) do
    @user = users(:john)
    setup_omniauth_mock(@user)
    VCR.insert_cassette('rswag/users')
  end

  after(:each) do
    VCR.eject_cassette
  end

  path '/v1/users/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'id'

    let(:id) { users(:john).id }

    get('show user') do
      tags 'Users'
      response(200, 'OK') do
        include_context 'run request test'
      end
    end

    patch('update user') do
      tags 'Users'
      consumes 'application/json'
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              name: { type: :string }
            }
          },
          required: %w[name]
        },
        required: %w[user]
      }

      response(200, 'OK') do
        let(:params) { { user: { name: users(:john).name } } }
        include_context 'run request test'
      end

      response(422, 'Unprocessable Entity') do
        let(:params) { { user: { name: nil } } }
        include_context 'run request test'
      end
    end
  end
end
