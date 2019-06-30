require 'test_helper'

class RecordTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:michael)
    @record = @user.records.build(weight: 78.0)
  end

  test "should be valid" do
    assert @record.valid?
  end

  test "user id should be present" do
    @record.user_id = nil
    assert_not @record.valid?
  end

  test "weight should be present" do
    @record.weight = " "
    assert_not @record.valid?
  end

  test "weight should have only numeric" do
    @record.weight = "78.0a"
    assert_not @record.valid?
  end

  
end
