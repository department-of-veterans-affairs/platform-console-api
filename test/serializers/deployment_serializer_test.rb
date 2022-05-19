require 'test_helper'

class AppsSerializerTest < ActionDispatch::IntegrationTest
  setup do
    @team = teams(:two)
    @app = apps(:two)
    @deployment = deployments(:one)
    @hash = DeploymentSerializer.new(@deployment).serializable_hash
  end

  test 'should serialize with the correct attributes' do
   assert_equal @hash.dig(:data, :attributes).keys, [:name, :created_at, :updated_at]
  end

  test 'should have the correct relationships' do
    assert_equal @hash.dig(:data, :relationships).keys, [:app]
  end

  test 'should have the correct self link' do
    assert_equal @hash.dig(:data, :links, :self), "#{ENV['BASE_URL']}/api/v1/teams/#{@deployment.app.team_id}/apps/#{@deployment.app.id}/deployments/#{@deployment.id}"
  end
end
