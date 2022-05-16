require 'test_helper'

class AppsSerializerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:john)
    @team = teams(:three)
    @app = apps(:three)
  end

end
