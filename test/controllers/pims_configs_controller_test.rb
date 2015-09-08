require 'test_helper'

class PimsConfigsControllerTest < ActionController::TestCase
  setup do
    @pims_config = pims_configs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pims_configs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pims_config" do
    assert_difference('PimsConfig.count') do
      post :create, pims_config: { description: @pims_config.description, property_name: @pims_config.property_name, property_value: @pims_config.property_value }
    end

    assert_redirected_to pims_config_path(assigns(:pims_config))
  end

  test "should show pims_config" do
    get :show, id: @pims_config
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @pims_config
    assert_response :success
  end

  test "should update pims_config" do
    patch :update, id: @pims_config, pims_config: { description: @pims_config.description, property_name: @pims_config.property_name, property_value: @pims_config.property_value }
    assert_redirected_to pims_config_path(assigns(:pims_config))
  end

  test "should destroy pims_config" do
    assert_difference('PimsConfig.count', -1) do
      delete :destroy, id: @pims_config
    end

    assert_redirected_to pims_configs_path
  end
end
