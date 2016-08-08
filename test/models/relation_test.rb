require 'test_helper'

class RelationTest < ActiveSupport::TestCase

  def setup
    @relation = Relation.new(
      sponser_id: users(:admin).id,
      sponsered_id: users(:member).id
    )
  end

  test "should be valid" do
    assert @relation.valid?
  end

  test "should require a sponser_id" do
    @relation.sponser_id = nil
    assert_not @relation.valid?
  end

  test "should require a sponsered_id" do
    @relation.sponsered_id = nil
    assert_not @relation.valid?
  end

end
