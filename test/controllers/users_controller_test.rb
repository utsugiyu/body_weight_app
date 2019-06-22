require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "should redirect to login url when access edit without login" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect to login url when access update without login" do
    patch user_path(@user), params: {user: {name: @user.name,
                                            email: @user.email}}
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect to root url when access edit as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert_redirected_to root_url
  end

  test "should redirect to root url when access update login as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: {user: {name: @user.name,
                                            email: @user.email}}
    assert_redirected_to root_url
  end

  test "can delete user when login as right user" do
    log_in_as(@user)
    assert_difference 'User.count', -1 do
      delete user_path(@user)
    end
    assert_redirected_to login_url
    assert_not flash.empty?
  end

  test "can't delete user when login as wrong user" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
    assert_not flash.empty?
  end
end
