require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:michael)
  end

  test "header layout test" do
    get root_path
    follow_redirect!
    assert_template 'sessions/new'
    assert_select "a[href=?]", root_path
    log_in_as(@user)
    assert is_logged_in?
    assert_redirected_to user_path(@user)
    follow_redirect!
    assert_select "a[href=?]", root_path, count:2
    assert_select "a[href=?]", edit_user_path(@user)
    assert_select "a[href=?][data-method=?]", logout_path, "delete"
  end
end
