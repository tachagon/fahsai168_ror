class RelationsController < ApplicationController

  before_action :logged_in_user
  before_action :find_relation, only: [:show, :edit, :update, :destroy]
  before_action :find_sponser, only: [:create, :update]
  before_action :limit_downline, only: [:create, :update]
  before_action :find_sponsered, only: [:new, :create]
  before_action :anti_dup, only: [:create, :update]

  def new
    @relation = Relation.new
  end

  def create
    @sponser.sponser(@sponsered)
    flash[:success] = "เพิ่มผู้แนะนำสำเร็จ"
    redirect_to user_path(@sponsered)
  end

  def edit

  end

  def update
    @relation.sponser_id = @sponser.id
    if @relation.save
      flash[:success] = "แก้ไขผู้แนะนำสำเร็จ"
      redirect_to user_path(@relation.sponsered)
    else
      render 'edit'
    end
  end

  def destroy
    @user = @relation.sponsered
    @relation.destroy
    flash[:success] = "ลบผู้แนะนำสำเร็จแล้ว"
    redirect_to user_path(@user)
  end

  private

    def find_relation
      @relation = Relation.find_by_id(params[:id])
      if @relation.nil?
        flash[:warning] = "ไม่พบความสัมพันธ์"
        redirect_to root_path
      end
    end

    def find_sponser
      @sponser = User.find_by_id(params[:sponser_id])
      if @sponser.nil?
        flash[:warning] = "ไม่พบผู้แนะนำ"
        redirect_to root_path
      end
    end

    def find_sponsered
      @sponsered = User.find_by_id(params[:sponsered_id])
      if @sponsered.nil?
        flash[:warning] = "ไม่พบผู้ถูกแนะนำ"
        redirect_to root_path
      end
    end

    def limit_downline
      if (!@sponser.nil?) && (@sponser.downline.count >= 3)
        flash[:warning] = "ไม่สามารถมีลูกทีมติดตัวเกิน 3 คนได้"
        if @relation
          redirect_to edit_relation_path(@relation)
        else
          redirect_to new_relation_path
        end
      end
    end

    def anti_dup
      # update
      if @relation
        if @relation.sponsered.id == @sponser.id
          flash[:warning] = "สมาชิกไม่สามารถแนะนำตนเองได้"
          redirect_to edit_relation_path(@relation)
        end
      else # create
        if @sponsered.id == @sponser.id
          flash[:warning] = "สมาชิกไม่สามารถแนะนำตนเองได้"
          redirect_to new_relation_path
        end
      end
    end

end
