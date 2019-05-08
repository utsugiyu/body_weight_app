require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get root_path
    assert_response :success
  end

  test "Correct title" do
    get signup_path
    assert_select "title", "Sign up | Body Weight App"
    get root_path
    assert_select "title", "Body Weight App"
  end


end
