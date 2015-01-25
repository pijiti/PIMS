require 'test_helper'

class HospitalUnitsControllerTest < ActionController::TestCase
  setup do
    @hospital_unit = hospital_units(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:hospital_units)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create hospital_unit" do
    assert_difference('HospitalUnit.count') do
      post :create, hospital_unit: { hospital_unit_description: @hospital_unit.hospital_unit_description, hospital_unit_name: @hospital_unit.hospital_unit_name }
    end

    assert_redirected_to hospital_unit_path(assigns(:hospital_unit))
  end

  test "should show hospital_unit" do
    get :show, id: @hospital_unit
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @hospital_unit
    assert_response :success
  end

  test "should update hospital_unit" do
    patch :update, id: @hospital_unit, hospital_unit: { hospital_unit_description: @hospital_unit.hospital_unit_description, hospital_unit_name: @hospital_unit.hospital_unit_name }
    assert_redirected_to hospital_unit_path(assigns(:hospital_unit))
  end

  test "should destroy hospital_unit" do
    assert_difference('HospitalUnit.count', -1) do
      delete :destroy, id: @hospital_unit
    end

    assert_redirected_to hospital_units_path
  end
end
