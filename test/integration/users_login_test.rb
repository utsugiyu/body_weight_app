require 'test_helper'



class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "login with valid information" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    delete logout_path
    follow_redirect!
    follow_redirect!
    assert_not is_logged_in?
    assert_template 'sessions/new'
    delete logout_path
  end

  test "login with remembering" do
    log_in_as(@user, remember_me:"1")
    assert_equal cookies["remember_token"], assigns(:user).remember_token
  end

  test "login without remembering" do
    log_in_as(@user, remember_me:"1")
    delete logout_path
    log_in_as(@user, remember_me:"0")
    assert_empty cookies["remember_token"]
  end
end
