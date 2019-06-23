require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "suzuki", email:"taro@gmail.com",
                    password:"666666", password_confirmation:"666666")

    @other_user = User.new(name: "suzuki", email:"taro@gmail.com",
                    password:"666666", password_confirmation:"666666")

  end

  test "should be valid user" do
    assert @user.valid?
  end

  test "should be invalid name" do
    @user.name = "  "
    assert_not @user.valid?
    @user.name = "a" * 21
    assert_not @user.valid?
  end

  test "should be invalid email" do
    @user.email = "  "
    assert_not @user.valid?
    @user.email = "a" * 101 + "@gmail.com"
    assert_not @user.valid?

    invalid_addresses = %w[taro@gmail..com taro@@gmail.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?
    end
  end


  test "Can save users" do
    assert_difference "User.count", 1 do
      @user.save
    end
  end

  test "email uniqueness" do
    @user.save
    assert_not @other_user.valid?
  end

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end
end
