require 'test_helper'

class PharmItemsControllerTest < ActionController::TestCase
  setup do
    @pharm_item = pharm_items(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pharm_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pharm_item" do
    assert_difference('PharmItem.count') do
      post :create, pharm_item: { number_of_brands: @pharm_item.number_of_brands, pharm_item_name: @pharm_item.pharm_item_name }
    end

    assert_redirected_to pharm_item_path(assigns(:pharm_item))
  end

  test "should show pharm_item" do
    get :show, id: @pharm_item
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @pharm_item
    assert_response :success
  end

  test "should update pharm_item" do
    patch :update, id: @pharm_item, pharm_item: { number_of_brands: @pharm_item.number_of_brands, pharm_item_name: @pharm_item.pharm_item_name }
    assert_redirected_to pharm_item_path(assigns(:pharm_item))
  end

  test "should destroy pharm_item" do
    assert_difference('PharmItem.count', -1) do
      delete :destroy, id: @pharm_item
    end

    assert_redirected_to pharm_items_path
  end
end
