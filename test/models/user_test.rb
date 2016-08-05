require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(
      member_code: "1234",
      f_name: "firstname",
      l_name: "lastname",
      phone: "0923456758",
      # role: "member",
      # position: positions(:not),
      iden_num: "1457032321385"
    )
  end

  test "should be valid" do
    assert @user.valid?
  end

  # ========== 1. member_code test ==========

  test "member_code should be present" do
    @user.member_code = "     "
    assert_not(@user.valid?)

    @user.member_code = nil
    assert_not(@user.valid?)
  end

  test "member_code should not be too long" do
    @user.member_code = "a" * 51
    assert_not @user.valid?
  end

  test "member_code should be unique" do
    duplicate_user = @user.dup
    duplicate_user.member_code = @user.member_code
    @user.save
    assert_not duplicate_user.valid?
  end

  test "member_code should be saved as lower-case" do
    mixed_case_member_code = "AdMIn"
    @user.member_code = mixed_case_member_code
    @user.save
    assert_equal mixed_case_member_code.downcase, @user.reload.member_code
  end

  # ========== 2. f_name test ==========

  test "f_name should be present" do
    @user.f_name = "     "
    assert_not @user.valid?

    @user.f_name = nil
    assert_not @user.valid?
  end

  test "f_name should not be too long" do
    @user.f_name = "a" * 101
    assert_not @user.valid?
  end

  # ========== 3. l_name test ==========

  test "l_name should be present" do
    @user.l_name = "     "
    assert_not @user.valid?

    @user.l_name = nil
    assert_not @user.valid?
  end

  test "l_name should not be too long" do
    @user.l_name = "a" * 101
    assert_not @user.valid?
  end

  # ========== 4. address test ==========

  test "address should not be too long" do
    @user.address = "a" * 256
    assert_not @user.valid?
  end

  # ========== 5. city test ==========

  test "city should not be too long" do
    @user.city = "a" * 256
    assert_not @user.valid?
  end

  # ========== 6. state test ==========

  test "state should not be too long" do
    @user.state = "a" * 256
    assert_not @user.valid?
  end

  # ========== 6. postal_code test ==========

  test "postal_code should not be too long" do
    @user.postal_code = "a" * 11
    assert_not @user.valid?
  end

  # ========== 8. phone test ==========

  test "phone should be present" do
    @user.phone = "     "
    assert_not @user.valid?

    @user.phone = nil
    assert_not @user.valid?
  end

  test "phone should not be too long" do
    @user.phone = "0" * 21
    assert_not @user.valid?
  end

  test "phone should be format" do
    @user.phone = "1826810461"
    assert_not @user.valid?

    @user.phone = "082a810461"
    assert_not @user.valid?

    @user.phone = "082-6810461"
    assert_not @user.valid?

    @user.phone = "0826810461"
    assert @user.valid?

    @user.phone = "034658471"
    assert @user.valid?
  end

  # ========== 9. line test ==========

  test "line should not be too long" do
    @user.line = "a" * 51
    assert_not @user.valid?
  end

  # ========== 10. role test ==========

  test "role should be present" do
    @user.role = "     "
    assert_not @user.valid?
  end

  test "role should be in all_role" do
    @user.role = "admin"
    assert @user.valid?

    @user.role = "mobile"
    assert @user.valid?

    @user.role = "stock"
    assert @user.valid?

    @user.role = "member"
    assert @user.valid?

    @user.role = "invalid"
    assert_not @user.valid?
  end

  test "role should be member as default" do
    @user.save
    @user.reload
    assert_equal(@user.role, "member")
  end

  # ========== 11. position test ==========

  test "position should be present" do
    @user.position = nil
    assert_not @user.valid?
  end

  test "position should default be no position" do
    @user.save
    assert_equal(@user.position.name, "no position")
  end

  # ========== 12. iden_num test ==========

  test "iden_num should be present" do
    @user.iden_num = "     "
    assert_not @user.valid?
  end

  test "iden_num should not be too long" do
    @user.iden_num = "0"*14
    assert_not @user.valid?
  end

  test "iden_num should accept valid" do
    iden_num_valid = [
      "7622803603308",
      "6245681003229",
      "3634724302631",
      "6414858655852",
      "4708582144250",
      "1326470440539",
      "8234355220706",
      "1103132458829",
      "1823877225226",
      "3071525878250"
    ]
    iden_num_valid.each do |iden_num|
      @user.iden_num = iden_num
      assert @user.valid?
    end

  end

  test "iden_num should reject invalid" do
    iden_num_invalid = [
      "7622803603309",
      "6245681003220",
      "3634724302632",
      "6414858655853",
      "4708582144251",
      "1326470440530",
      "8234355220707",
      "1103132458828",
      "1823877225227",
      "3071525878251"
    ]
    iden_num_invalid.each do |iden_num|
      @user.iden_num = iden_num
      assert_not @user.valid?
    end
  end

  test "iden_num should be unique" do
    duplicate_user = @user.dup
    duplicate_user.iden_num = @user.iden_num
    @user.save
    assert_not duplicate_user.valid?
  end

  # ========== 13. email test ==========

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
     valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
     valid_addresses.each do |valid_address|
       @user.email = valid_address
       assert @user.valid?, "#{valid_address.inspect} should be valid"
     end
  end

   test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    @user.email = "user@example.com"
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  # ========== 14. password test ==========

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = "" * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 3
    assert_not @user.valid?
  end

  test "password should be default if password is nil" do
    @user.iden_num = "1457032321385"
    @user.save
    assert_equal(@user.reload.password, @user.reload.iden_num.split(//).last(4).join)
  end

  # test "password should be valid if password is not nil" do
  #   password = "123456"
  #   @user.password = @user.password_confirmation = password
  #   @user.save
  #   assert_equal(@user.reload.password, password)
  # end

  # ========== 15. authenticated? test ==========

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?('')
  end

end
