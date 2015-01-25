require 'test_helper'

class MarketersControllerTest < ActionController::TestCase
  setup do
    @marketer = marketers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:marketers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create marketer" do
    assert_difference('Marketer.count') do
      post :create, marketer: { marketer_name: @marketer.marketer_name }
    end

    assert_redirected_to marketer_path(assigns(:marketer))
  end

  test "should show marketer" do
    get :show, id: @marketer
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @marketer
    assert_response :success
  end

  test "should update marketer" do
    patch :update, id: @marketer, marketer: { marketer_name: @marketer.marketer_name }
    assert_redirected_to marketer_path(assigns(:marketer))
  end

  test "should destroy marketer" do
    assert_difference('Marketer.count', -1) do
      delete :destroy, id: @marketer
    end

    assert_redirected_to marketers_path
  end
end
