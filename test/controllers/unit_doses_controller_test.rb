require 'test_helper'

class UnitDosesControllerTest < ActionController::TestCase
  setup do
    @unit_dose = unit_doses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:unit_doses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create unit_dose" do
    assert_difference('UnitDose.count') do
      post :create, unit_dose: { type: @unit_dose.type, unit_dose_name: @unit_dose.unit_dose_name }
    end

    assert_redirected_to unit_dose_path(assigns(:unit_dose))
  end

  test "should show unit_dose" do
    get :show, id: @unit_dose
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @unit_dose
    assert_response :success
  end

  test "should update unit_dose" do
    patch :update, id: @unit_dose, unit_dose: { type: @unit_dose.type, unit_dose_name: @unit_dose.unit_dose_name }
    assert_redirected_to unit_dose_path(assigns(:unit_dose))
  end

  test "should destroy unit_dose" do
    assert_difference('UnitDose.count', -1) do
      delete :destroy, id: @unit_dose
    end

    assert_redirected_to unit_doses_path
  end
end
