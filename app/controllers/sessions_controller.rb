class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(member_code: params[:session][:member_code].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      flash[:success] = "เข้าสู่ระบบสำเร็จแล้ว"
      redirect_back_or root_path
    else
      flash.now[:danger] = 'เข้าสู่ระบบไม่สำเร็จ รหัสสมาชิกหรือรหัสผ่านไม่ถูกต้อง'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    flash[:success] = "ออกจากระบบสำเร็จ"
    redirect_to root_url
  end

end
