require 'test_helper'

class StoreOperationsControllerTest < ActionController::TestCase
  setup do
    @store_operation = store_operations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:store_operations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create store_operation" do
    assert_difference('StoreOperation.count') do
      post :create, store_operation: { payment_required: @store_operation.payment_required, store_operation_name: @store_operation.store_operation_name }
    end

    assert_redirected_to store_operation_path(assigns(:store_operation))
  end

  test "should show store_operation" do
    get :show, id: @store_operation
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @store_operation
    assert_response :success
  end

  test "should update store_operation" do
    patch :update, id: @store_operation, store_operation: { payment_required: @store_operation.payment_required, store_operation_name: @store_operation.store_operation_name }
    assert_redirected_to store_operation_path(assigns(:store_operation))
  end

  test "should destroy store_operation" do
    assert_difference('StoreOperation.count', -1) do
      delete :destroy, id: @store_operation
    end

    assert_redirected_to store_operations_path
  end
end
