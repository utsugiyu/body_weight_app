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

  test "period tabs test" do
    log_in_as(@user)
    get user_path(@user)
    assert_select 'a.active', "3days"
    assert_select "a[href=?]", "/users/#{@user.id}?duration=3days"
    assert_select "a[href=?]", "/users/#{@user.id}?duration=week"
    assert_select "a[href=?]", "/users/#{@user.id}?duration=month"
    assert_select "a[href=?]", "/users/#{@user.id}?duration=all"
    get "/users/#{@user.id}?duration=week"
    assert_select 'a.active', "Week"
    assert_select "a[href=?]", "/users/#{@user.id}?duration=3days"
    assert_select "a[href=?]", "/users/#{@user.id}?duration=week"
    assert_select "a[href=?]", "/users/#{@user.id}?duration=month"
    assert_select "a[href=?]", "/users/#{@user.id}?duration=all"
    get "/users/#{@user.id}?duration=month"
    assert_select 'a.active', "Month"
    assert_select "a[href=?]", "/users/#{@user.id}?duration=3days"
    assert_select "a[href=?]", "/users/#{@user.id}?duration=week"
    assert_select "a[href=?]", "/users/#{@user.id}?duration=month"
    assert_select "a[href=?]", "/users/#{@user.id}?duration=all"
    get "/users/#{@user.id}?duration=all"
    assert_select 'a.active', "All"
    assert_select "a[href=?]", "/users/#{@user.id}?duration=3days"
    assert_select "a[href=?]", "/users/#{@user.id}?duration=week"
    assert_select "a[href=?]", "/users/#{@user.id}?duration=month"
    assert_select "a[href=?]", "/users/#{@user.id}?duration=all"
    get "/users/#{@user.id}?duration=3days"
    assert_select 'a.active', "3days"
    assert_select "a[href=?]", "/users/#{@user.id}?duration=3days"
    assert_select "a[href=?]", "/users/#{@user.id}?duration=week"
    assert_select "a[href=?]", "/users/#{@user.id}?duration=month"
    assert_select "a[href=?]", "/users/#{@user.id}?duration=all"
  end

  test "delete button test" do
    log_in_as(@user)
    get user_path(@user)
    first_records = @user.records.take(7)
    first_records.each do |record|
      assert_select "a[href=?][data-method=?]", "/records/#{record.id}", "delete"
    end
  end

  test "paginate test" do
    log_in_as(@user)
    get user_path(@user)
    assert_select "a[href=?]", "/users/#{@user.id}?page=2"
  end


  test "keep paginate when send valid form" do
    get "/users/#{@user.id}"
  end

  test "keep paginate when send invalid form" do

  end

end
