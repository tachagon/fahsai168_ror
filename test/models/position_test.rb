require 'test_helper'

class PositionTest < ActiveSupport::TestCase

  def setup
    @position = Position.new(
      name: "no position",
      layer: 0,
      min_pv: 0
    )
  end

  test "should be valid" do
    assert @position.valid?
  end

  # ========== 1. name test ==========

  test "name should be present" do
    @position.name = "     "
    assert_not(@position.valid?)

    @position.name = nil
    assert_not(@position.valid?)
  end

  test "name should not be too long" do
    @position.name = "a" * 51
    assert_not @position.valid?
  end

  # ========== 2. layer test ==========

  test "layer should be present" do
    @position.layer = nil
    assert_not(@position.valid?)
  end

  test "layer should be only integer" do
    @position.layer = 2.5
    assert_not @position.valid?

    @position.layer = "a"
    assert_not @position.valid?
  end

  test "layer should greater than or equal to 0" do
    @position.layer = -1
    assert_not @position.valid?

    @position.layer = 0
    assert @position.valid?
  end

  # ========== 3. min_pv test ==========

  test "min_pv should be present" do
    @position.min_pv = nil
    assert_not(@position.valid?)
  end

  test "min_pv should be only integer" do
    @position.min_pv = 2.5
    assert_not @position.valid?

    @position.min_pv = "a"
    assert_not @position.valid?
  end

  test "min_pv should greater than or equal to 0" do
    @position.min_pv = -1
    assert_not @position.valid?

    @position.min_pv = 0
    assert @position.valid?
  end

end
