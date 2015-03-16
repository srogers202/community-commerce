require 'test_helper'

class ProductTargetsControllerTest < ActionController::TestCase
  setup do
    @product_target = product_targets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:product_targets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product_target" do
    assert_difference('ProductTarget.count') do
      post :create, product_target: { minqty: @product_target.minqty, order: @product_target.order, price: @product_target.price, priceLessPrevious: @product_target.priceLessPrevious, product: @product_target.product }
    end

    assert_redirected_to product_target_path(assigns(:product_target))
  end

  test "should show product_target" do
    get :show, id: @product_target
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @product_target
    assert_response :success
  end

  test "should update product_target" do
    patch :update, id: @product_target, product_target: { minqty: @product_target.minqty, order: @product_target.order, price: @product_target.price, priceLessPrevious: @product_target.priceLessPrevious, product: @product_target.product }
    assert_redirected_to product_target_path(assigns(:product_target))
  end

  test "should destroy product_target" do
    assert_difference('ProductTarget.count', -1) do
      delete :destroy, id: @product_target
    end

    assert_redirected_to product_targets_path
  end
end
