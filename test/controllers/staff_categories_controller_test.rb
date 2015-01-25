require 'test_helper'

class StaffCategoriesControllerTest < ActionController::TestCase
  setup do
    @staff_category = staff_categories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:staff_categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create staff_category" do
    assert_difference('StaffCategory.count') do
      post :create, staff_category: { staff_category_name: @staff_category.staff_category_name }
    end

    assert_redirected_to staff_category_path(assigns(:staff_category))
  end

  test "should show staff_category" do
    get :show, id: @staff_category
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @staff_category
    assert_response :success
  end

  test "should update staff_category" do
    patch :update, id: @staff_category, staff_category: { staff_category_name: @staff_category.staff_category_name }
    assert_redirected_to staff_category_path(assigns(:staff_category))
  end

  test "should destroy staff_category" do
    assert_difference('StaffCategory.count', -1) do
      delete :destroy, id: @staff_category
    end

    assert_redirected_to staff_categories_path
  end
end
