require "test_helper"

class CustomersControllerTest < ActionDispatch::IntegrationTest
  test "should get profile" do
    get customers_profile_url
    assert_response :success
  end
end
