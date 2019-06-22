require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test "invalid information signup" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    assert_select 'div#error_explanation'
    assert_select 'div.alert-danger'
  end

  test "valid information signup" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "abcdefg",
                                         email: "user@valid.com",
                                         password: "666666",
                                         password_confirmation: "666666" } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end
