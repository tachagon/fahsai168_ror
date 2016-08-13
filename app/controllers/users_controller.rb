class UsersController < ApplicationController

  include UsersHelper

  before_action :logged_in_user
  before_action :find_user, only: [:show, :edit, :update, :destroy, :update_role, :update_position, :chart, :edit_sponser]
  before_action :find_sponser, only: [:new, :create]
  before_action :limit_downline, only: [:create, :update]
  before_action :correct_user_or_admin, only: [:edit, :update]
  # before_action :not_member_user, only: [:new, :create]
  before_action :empty_email, only: [:create, :update]
  before_action :admin_only, only: [:index, :destroy, :update_role, :update_position]

  def index
    @users = User.paginate(page: params[:page])
  end

  def show

  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "เพิ่มสมาชิกใหม่สำเร็จ"
      create_downline
    else
      render 'new'
    end
  end

  def edit

  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "แก้ไขโปรไฟล์สำเร็จแล้ว"
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end

  def update_role
    if @user.update_attributes(user_role_params)
      flash[:success] = 'อัปเดทบทบาทสำเร็จ'
      redirect_to users_path
    else
      flash[:danger] = "อัปเดทบทบาทไม่สำเร็จ"
      redirect_to users_path
    end
  end

  def update_position
    if @user.update_attributes(user_position_id_params)
      flash[:success] = 'อัปเดทตำแหน่งสำเร็จ'
      redirect_to users_path
    else
      flash[:danger] = "อัปเดทตำแหน่งไม่สำเร็จ"
      redirect_to users_path
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "ลบสมาชิกสำเร็จแล้ว"
    redirect_to users_path
  end

  def chart
    @downlines = @user.downline
  end

  # def new_sponser
  #   @sponser = User.find_by("member_code" => params[:member_code])
  #   if @sponser
  #     redirect_to new_user_path(sponser_id: @sponser.id)
  #   else
  #     flash[:danger] = "ไม่พบผู้แนะนำ กรุณาตรวจสอบรหัสสมาชิกผู้แนะนำใหม่"
  #     redirect_to new_user_path
  #   end
  # end

  # def edit_sponser
  #   @sponser = User.find_by("member_code" => params[:member_code])
  #   if @sponser
  #     if @sponser.downline.count >= 3
  #       flash[:danger] = "ไม่สามารถมีลูกทีมติดตัวเกิน 3 คนได้"
  #       redirect_to @user and return
  #     end


  #   else
  #     flash[:danger] = "ไม่พบผู้แนะนำ กรุณาตรวจสอบรหัสสมาชิกผู้แนะนำใหม่"
  #     redirect_to @user
  #   end
  # end

  def search_user
    @user = User.find_by(params[:attr] => params[:query])
    if @user
      redirect_to :back and return
    else
      flash[:danger] = "ค้นหาสมาชิกไม่พบ"
      redirect_to :back
    end
  end

  def search_users
    @users = User.search(params[:attr], params[:query])
    # @users = User.search('member_code', 'tachagon')
    respond_to do |format|
      format.html{redirect_to :back}
      format.json{render json: @users}
      format.xml{render xml: @users}
    end
  end

  # ==================================================
  # Private Function
  # ==================================================

  private

    def user_params
      params.require(:user).permit(
        :member_code,
        :password,
        :password_confirmation,
        :f_name,
        :l_name,
        :address,
        :city,
        :state,
        :postal_code,
        :email,
        :phone,
        :line,
        :iden_num
      )
    end

    def user_role_params
      params.permit(:role)
    end

    def user_position_id_params
      params.permit(:position_id)
    end

    def empty_email
      params[:user][:email] = nil if params[:user][:email] == ""
    end

    # Confirms the correct user.
    def correct_user_or_admin
      @user = User.find(params[:id])
      redirect_to(root_url) if !(current_user?(@user) || current_user.is_admin?)
    end

    # Confirms an admin user.
    def admin_only
      unless role?(current_user, "admin")
        flash[:warning] = "เฉพาะ Admin เท่านั้น"
        redirect_to(root_url)
      end
    end

    def not_member_user
      redirect_to root_url if role?(current_user, "member")
    end

    def find_user
      @user = User.find_by_id(params[:id]) || User.find_by_id(params[:user_id])
      if @user.nil?
        flash[:warning] = "ไม่พบผู้ใช้งาน"
        redirect_to root_path
      end
    end

    def find_sponser
      @sponser = User.find_by_id(params[:sponser_id])
    end

    def limit_downline
      if (!@sponser.nil?) && (@sponser.downline.count >= 3)
        flash[:warning] = "ไม่สามารถมีลูกทีมติดตัวเกิน 3 คนได้"
        redirect_to new_user_path
      end
    end

    def create_downline
      unless @sponser.nil?
        @sponser.sponser(@user)
        redirect_to user_chart_path(@sponser)
      else
        redirect_to new_relation_path(sponsered_id: @user.id)
      end
    end

end
