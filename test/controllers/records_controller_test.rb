require 'test_helper'

class RecordsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
    @record = records(:orange)
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Record.count' do
      post "/users/#{@user.id}", params: { record: { weight: 15.00 } }
    end
    assert_redirected_to login_url
  end

  test "create record  with logged in" do
    log_in_as(@user)
    assert_difference 'Record.count', 1 do
      post "/users/#{@user.id}", params: { record: { weight: 15.00 } }
    end
    assert_not flash.empty?
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Record.count' do
      delete record_path(@record)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy as not correct user" do
    log_in_as(@other_user)
    assert_no_difference 'Record.count' do
      delete record_path(@record)
    end
    assert_redirected_to root_url
  end

  test "destroy as correct user with logged in" do
    log_in_as(@user)
    assert_difference 'Record.count', -1 do
      delete record_path(@record)
    end
    assert_not flash.empty?
    assert_redirected_to request.referrer || root_url
  end

end
