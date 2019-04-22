class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:show, :edit, :update, :destroy]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)

    if @user.save
      UserMailer.creation_email(@user).deliver_now
      flash[:success] = 'ユーザを登録しました。'
      redirect_to login_path
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new
    end
  end
  
  def show
    @hotsprings = @user.hotsprings.uniq
    @hotsprings_count = @user.hotsprings.count
    @wannagoes_count = @user.wannago_hotsprings.count
    @wents_count = @user.went_hotsprings.count
  end
  
  def edit
  end
  
  def update
    if @user.update(user_params)
      flash[:success] = "会員情報を更新しました。"
      redirect_to @user
    else
      flash.now[:danger] = "更新に失敗しました。"
      render :edit
    end
  end
  
  def destroy
    @user.destroy
    flash[:success] = "退会しました。"
    redirect_to root_url
  end
  
  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  
  def correct_user
    unless current_user == User.find_by(id: params[:id])
      flash[:danger] = "不正なアクセスです。"
      redirect_back(fallback_location: root_path)
    end
  end
  
  def set_user
    @user = User.find_by(id: params[:id])
  end  
end
