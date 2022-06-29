# frozen_string_literal: true

# require 'swagger_helper'

# RSpec.describe 'api/v1/apps', type: :request do
#   fixtures :users, :teams, :apps

#   before(:each) do
#     @user = users(:john)
#     setup_omniauth_mock(@user)
#     # VCR.insert_cassette('rswag/apps')
#   end

#   after(:each) do
#     VCR.eject_cassette
#   end

#   path '/v1/teams/{team_id}/apps' do
#     let(:team_id) { teams(:three).id }
#     let(:id) { apps(:four).id }

#     get('list apps') do
#       response(200, 'successful') do
#         include_context 'run request test'
#       end
#     end

#     post('create app') do
#       response(200, 'successful') do
#         include_context 'run request test'
#       end
#     end
#   end

#   # path '/v1/teams/{team_id}/apps/{id}' do
#   #   parameter name: 'team_id', in: :path, type: :int, description: 'team_id'
#   #   parameter name: 'id', in: :path, type: :int, description: 'id'

#   #   let(:team_id) { teams(:three).id }
#   #   let(:id) { apps(:four).id }

#   #   get('show app') do
#   #     response(200, 'successful') do
#   #       include_context 'run request test'
#   #     end
#   #   end

#   #   patch('update app') do
#   #     response(200, 'successful') do
#   #       include_context 'run request test'
#   #     end
#   #   end

#   #   put('update app') do
#   #     response(200, 'successful') do
#   #       include_context 'run request test'
#   #     end
#   #   end

#   #   delete('delete app') do
#   #     response(200, 'successful') do
#   #       include_context 'run request test'
#   #     end
#   #   end
#   # end
# end
