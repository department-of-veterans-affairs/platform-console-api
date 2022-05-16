require 'test_helper'

class UserSerializerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:john)
    @team = teams(:three)
    @app = apps(:three)
  end

end
