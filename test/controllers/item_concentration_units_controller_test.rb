require 'test_helper'

class ItemConcentrationUnitsControllerTest < ActionController::TestCase
  setup do
    @item_concentration_unit = item_concentration_units(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:item_concentration_units)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create item_concentration_unit" do
    assert_difference('ItemConcentrationUnit.count') do
      post :create, item_concentration_unit: { conc_unit_name: @item_concentration_unit.conc_unit_name }
    end

    assert_redirected_to item_concentration_unit_path(assigns(:item_concentration_unit))
  end

  test "should show item_concentration_unit" do
    get :show, id: @item_concentration_unit
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @item_concentration_unit
    assert_response :success
  end

  test "should update item_concentration_unit" do
    patch :update, id: @item_concentration_unit, item_concentration_unit: { conc_unit_name: @item_concentration_unit.conc_unit_name }
    assert_redirected_to item_concentration_unit_path(assigns(:item_concentration_unit))
  end

  test "should destroy item_concentration_unit" do
    assert_difference('ItemConcentrationUnit.count', -1) do
      delete :destroy, id: @item_concentration_unit
    end

    assert_redirected_to item_concentration_units_path
  end
end
