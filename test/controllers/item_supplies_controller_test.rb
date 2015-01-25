require 'test_helper'

class ItemSuppliesControllerTest < ActionController::TestCase
  setup do
    @item_supply = item_supplies(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:item_supplies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create item_supply" do
    assert_difference('ItemSupply.count') do
      post :create, item_supply: { brand_id: @item_supply.brand_id }
    end

    assert_redirected_to item_supply_path(assigns(:item_supply))
  end

  test "should show item_supply" do
    get :show, id: @item_supply
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @item_supply
    assert_response :success
  end

  test "should update item_supply" do
    patch :update, id: @item_supply, item_supply: { brand_id: @item_supply.brand_id }
    assert_redirected_to item_supply_path(assigns(:item_supply))
  end

  test "should destroy item_supply" do
    assert_difference('ItemSupply.count', -1) do
      delete :destroy, id: @item_supply
    end

    assert_redirected_to item_supplies_path
  end
end
