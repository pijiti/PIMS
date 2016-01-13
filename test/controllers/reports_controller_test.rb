require 'test_helper'

class ReportsControllerTest < ActionController::TestCase
  test "should get drugs" do
    get :drugs
    assert_response :success
  end

end
