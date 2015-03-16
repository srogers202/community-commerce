require 'test_helper'

class ProductExpirationsControllerTest < ActionController::TestCase
  setup do
    @product_expiration = product_expirations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:product_expirations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product_expiration" do
    assert_difference('ProductExpiration.count') do
      post :create, product_expiration: { complete: @product_expiration.complete, expiration: @product_expiration.expiration, product: @product_expiration.product, shop: @product_expiration.shop }
    end

    assert_redirected_to product_expiration_path(assigns(:product_expiration))
  end

  test "should show product_expiration" do
    get :show, id: @product_expiration
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @product_expiration
    assert_response :success
  end

  test "should update product_expiration" do
    patch :update, id: @product_expiration, product_expiration: { complete: @product_expiration.complete, expiration: @product_expiration.expiration, product: @product_expiration.product, shop: @product_expiration.shop }
    assert_redirected_to product_expiration_path(assigns(:product_expiration))
  end

  test "should destroy product_expiration" do
    assert_difference('ProductExpiration.count', -1) do
      delete :destroy, id: @product_expiration
    end

    assert_redirected_to product_expirations_path
  end
end
