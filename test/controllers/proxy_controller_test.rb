require 'test_helper'

class ProxyControllerTest < ActionController::TestCase
  test "should get product_targets" do
    get :product_targets
    assert_response :success
  end

end
