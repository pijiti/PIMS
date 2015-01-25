require 'test_helper'

class StoreSelectionControllerTest < ActionController::TestCase
  test "should get select" do
    get :select
    assert_response :success
  end

end
