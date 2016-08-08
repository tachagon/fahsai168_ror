require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @admin = users(:admin)
    @mobile = users(:mobile)
    @stock = users(:stock)
    @member = users(:member)
  end

  # ===========================================================================
  # 1. index test
  # ===========================================================================

  test "should redirect index when not logged in" do
    get :index
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect index when not log in as admin user" do
    users = [@mobile, @stock, @member]
    users.each { |user|
      log_in_as user
      get :index
      assert_redirected_to root_url
    }
  end

  test "should get index" do
    log_in_as @admin
    get :index
    assert_template 'users/index'
    assert_response :success
  end

  # ===========================================================================
  # 2. show test
  # ===========================================================================

  test "should redirect show when not logged in" do
    get :show, id: @admin
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect show when id invalid" do
    log_in_as @admin
    get :show, id: -1
    assert_redirected_to root_url
  end

  test "should get show" do
    log_in_as @member
    get :show, id: @member
    assert_template 'users/show'
    assert_response :success
  end

  # ===========================================================================
  # 3. new test
  # ===========================================================================

  test "should redirect new when not logged in" do
    get :new
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should get new" do
    log_in_as @member
    get :new
    assert_template 'users/new'
    assert_response :success
  end

  # ===========================================================================
  # 4. create test
  # ===========================================================================

  test "should  redirect create when not logged in" do
    post :create, user: {
      member_code: "9999",
      f_name: "firstname",
      l_name: "lastname",
      phone: "0826810461",
      iden_num: "2108241625770"
    }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should render create when invalid form" do
    log_in_as @member
    assert_no_difference "User.count" do
      post :create, user: {
        member_code: "",
        f_name: "",
        l_name: "",
        phone: "",
        iden_num: ""
      }
    end
    assert_template 'users/new'
  end

  test "should redirect create when success" do
    log_in_as @member
    assert_difference "User.count", 1 do
      post :create, user: {
        member_code: "9999",
        f_name: "firstname",
        l_name: "lastname",
        phone: "0826810461",
        iden_num: "2108241625770"
      }
    end
    new_user = User.last
    assert_redirected_to user_url(new_user)
  end

  test "should redirect create when fill form with email" do
    email = "exz@example.com"
    log_in_as @member
    assert_difference "User.count", 1 do
      post :create, user: {
        member_code: "9999",
        f_name: "firstname",
        l_name: "lastname",
        phone: "0826810461",
        iden_num: "2108241625770",
        email: email
      }
    end
    new_user = User.last
    assert_redirected_to user_url(new_user)
    assert_equal(new_user.email, email)
  end

  test "should assign role when create" do
    role = "admin"
    log_in_as @member
    assert_difference "User.count", 1 do
      post :create, user: {
        member_code: "9999",
        f_name: "firstname",
        l_name: "lastname",
        phone: "0826810461",
        iden_num: "2108241625770",
        role: role
      }
    end
    new_user = User.last
    assert_not_equal(new_user.role, role)
    assert_equal(new_user.role, "member")
  end

  test "should assign position when create" do
    silver = positions(:silver)
    no_position = positions(:not)
    log_in_as @member
    assert_difference "User.count", 1 do
      post :create, user: {
        member_code: "9999",
        f_name: "firstname",
        l_name: "lastname",
        phone: "0826810461",
        iden_num: "2108241625770",
        position: silver
      }
    end
    new_user = User.last
    assert_not_equal(new_user.position.name, silver.name)
    assert_equal(new_user.position.name, no_position.name)
  end

  # ===========================================================================
  # 5. edit test
  # ===========================================================================

  test "should redirect edit when not logged in" do
    get :edit, id: @admin
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when not correct uesr" do
    log_in_as @mobile
    get :edit, id: @stock
    assert_redirected_to root_url
  end

  test "should redirect edit when id invalid" do
    log_in_as @admin
    get :edit, id: -1
    assert_redirected_to root_url
  end

  test "should get edit when correct user" do
    log_in_as @member
    get :edit, id: @member
    assert_template 'users/edit'
    assert_response :success
  end

  test "should get edit when admin user" do
    log_in_as @admin
    get :edit, id: @member
    assert_template 'users/edit'
    assert_response :success
  end

  # ===========================================================================
  # 6. update test
  # ===========================================================================

  test "should  redirect update when not logged in" do
    patch :update, id: @member, user: {
      member_code: "9999",
      f_name: "firstname",
      l_name: "lastname",
      phone: "0826810461",
      iden_num: "2108241625770"
    }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when id invalid" do
    log_in_as @member
    patch :update, id: -1, user: {
      member_code: "9999",
      f_name: "firstname",
      l_name: "lastname",
      phone: "0826810461",
      iden_num: "2108241625770"
    }
    assert_redirected_to root_url
  end

  test "should redirect update when not correct user" do
    log_in_as @member
    patch :update, id: @stock, user: {
      member_code: "9999",
      f_name: "firstname",
      l_name: "lastname",
      phone: "0826810461",
      iden_num: "2108241625770"
    }
    assert_redirected_to root_url
  end

  test "should render update when invalid form" do
    log_in_as @member
    patch :update, id: @member, user: {
      member_code: "",
      f_name: "",
      l_name: "",
      phone: "",
      iden_num: ""
    }
    assert_template 'users/edit'
  end

  test "should redirect update when success" do
    log_in_as @member
    member_code = "9999"
    f_name = "new_firstname"
    l_name = "new_lastname"
    email = "xyz@example.com"
    patch :update, id: @member, user: {
      member_code: member_code,
      f_name: f_name,
      l_name: l_name,
      phone: @member.phone,
      iden_num: @member.iden_num,
      email: email
    }
    @member.reload
    assert_redirected_to user_url(@member)
    assert_equal(@member.member_code, member_code)
    assert_equal(@member.f_name, f_name)
    assert_equal(@member.l_name, l_name)
    assert_equal(@member.email, email)
  end

  test "admin should update other user" do
    log_in_as @admin
    member_code = "9999"
    f_name = "new_firstname"
    l_name = "new_lastname"
    email = "xyz@example.com"
    patch :update, id: @stock, user: {
      member_code: member_code,
      f_name: f_name,
      l_name: l_name,
      phone: @stock.phone,
      iden_num: @stock.iden_num,
      email: email
    }
    @stock.reload
    assert_redirected_to user_url(@stock)
    assert_equal(@stock.member_code, member_code)
    assert_equal(@stock.f_name, f_name)
    assert_equal(@stock.l_name, l_name)
    assert_equal(@stock.email, email)
  end

  test "should not assign role via update" do
    role = "admin"
    log_in_as @member
    patch :update, id: @member, user: {
      member_code: @member.member_code,
      f_name: @member.f_name,
      l_name: @member.l_name,
      phone: @member.phone,
      iden_num: @member.iden_num,
      role: role
    }
    @member.reload
    assert_redirected_to user_url(@member)
    assert_not_equal(@member.role, role)
    assert_equal(@member.role, "member")
  end

  test "should not assign posion via update" do
    position = positions(:gold)
    no_position = positions(:not)
    log_in_as @member
    patch :update, id: @member, user: {
      member_code: @member.member_code,
      f_name: @member.f_name,
      l_name: @member.l_name,
      phone: @member.phone,
      iden_num: @member.iden_num,
      position: position
    }
    @member.reload
    assert_redirected_to user_url(@member)
    assert_not_equal(@member.position.name, position.name)
    assert_equal(@member.position.name, no_position.name)
  end

  # ===========================================================================
  # 7. update_role test
  # ===========================================================================

  test "should  redirect update_role when not logged in" do
    post :update_role, user_id: @member, role: "admin"
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update_role when not logged in as admin" do
    log_in_as @member
    post :update_role, user_id: @member, role: "admin"
    assert_redirected_to root_url
  end

  test "should redirect update_role when role not correct" do
    log_in_as @admin
    role = @member.role
    post :update_role, user_id: @member, role: "invalid"
    assert_not flash.empty?
    @member.reload
    assert_not_equal(@member.role, "admin")
    assert_equal(@member.role, role)
  end

  test "should redirect update_role when success" do
    log_in_as @admin
    role = @member.role
    post :update_role, user_id: @member, role: "admin"
    assert_not flash.empty?
    @member.reload
    assert_not_equal(@member.role, role)
    assert_equal(@member.role, "admin")
  end

  # ===========================================================================
  # 8. update_position test
  # ===========================================================================

  test "should  redirect update_position when not logged in" do
    gold = positions(:gold)
    post :update_position, user_id: @member, position_id: gold.id
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update_position when not logged in as admin" do
    log_in_as @member
    gold = positions(:gold)
    post :update_position, user_id: @member, position_id: gold.id
    assert_redirected_to root_url
  end

  test "should redirect update_position when role not correct" do
    log_in_as @admin
    position_id = @member.position.id
    post :update_position, user_id: @member, position_id: -1
    assert_not flash.empty?
    @member.reload
    assert_not_equal(@member.position.id, -1)
    assert_equal(@member.position.id, position_id)
  end

  test "should redirect update_position when success" do
    log_in_as @admin
    position_id = @member.position.id
    gold = positions(:gold)
    post :update_position, user_id: @member, position_id: gold.id
    assert_not flash.empty?
    @member.reload
    assert_not_equal(@member.position.id, position_id)
    assert_equal(@member.position.id, gold.id)
  end

  # ===========================================================================
  # 9. destroy test
  # ===========================================================================

  test "should redirect destroy when not logged in" do
    delete :destroy, id: @member
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should reditect destroy when id invalid" do
    log_in_as @admin
    assert_no_difference "User.count" do
      delete :destroy, id: -1
    end
    assert_redirected_to root_url
  end

  test "should redirect destroy when not logged in as admin" do
    log_in_as @stock
    assert_no_difference "User.count" do
      delete :destroy, id: @member
    end
    assert_redirected_to root_url
  end

  test "should redirect destroy when success" do
    log_in_as @admin
    assert_difference "User.count", -1 do
      delete :destroy, id: @member
    end
    assert_redirected_to users_url
  end

end
