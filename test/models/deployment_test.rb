# frozen_string_literal: true

require 'test_helper'

class DeploymentTest < ActiveSupport::TestCase
  setup do
    @app = apps(:one)
    @team = teams(:one)
    @deployment = deployments(:one)
  end

  test 'valid team' do
    @deployment.update(name: 'deployment-test')
    assert @deployment.valid?
  end

  test 'valid team with papertrail versions' do
    @deployment.update(name: 'deployment-test')
    assert @deployment.valid?
    assert_not_nil @deployment.versions
  end

  test 'invalid team' do
    deployment = Deployment.new
    assert_not deployment.valid?
  end
end
