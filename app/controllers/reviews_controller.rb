class ReviewsController < ApplicationController
  before_action :set_hotspring
  before_action :set_review, only: [:show, :edit, :update, :destroy]
  before_action :require_user_logged_in, only: [:new]
  before_action :correct_user, only: [:edit, :update, :destroy]
  
  def new
    if current_user.went?(@hotspring)
      @review = Review.new
    else
      flash[:warning] = "レビューを投稿するには「行った」に保存する必要があります"
      redirect_to "/hotspring/#{@hotspring.code}/"
    end
  end

  def create
    @review = current_user.reviews.new(review_params)
    @review[:hotspring_id] = @hotspring.id
    
    if @review.save
      flash[:success] = "レビューを投稿しました"
      redirect_to "/hotspring/#{@hotspring.code}/reviews"
    else
      flash.now[:danger] = "レビューを投稿できませんでした"
      render :new
    end
  end

  def index
    @reviews = @hotspring.reviews.all.order("updated_at desc").page(params[:page])
  end
  
  def show
  end

  def edit
  end

  def update
    
    if @review.update_attributes(review_params)
      flash[:success] = "レビューを更新しました"
      redirect_to "/hotspring/#{@hotspring.code}/reviews"
    else
      flash.now[:danger] = "レビューを更新できませんでした"
      render :edit
    end
  end

  def destroy
    
    if @review.destroy
      flash[:success] = "レビューを削除しました。"
      redirect_to "/hotspring/#{@hotspring.code}/reviews"
    else
      flash.now[:danger] = "レビューを削除できませんでした。"
      render :index
    end
  end
  
  private
  
  def review_params
    params.require(:review).permit(:title, :comment, :satisfaction_degree, :visit_date)
  end
  
  def set_hotspring
    @hotspring = Hotspring.find_by(code: params[:code])
    if @hotspring.nil?
      uri = URI.parse(hotelNo_search(params[:code]))
      json = Net::HTTP.get(uri)
      result = JSON.parse(json, {symbolize_names: true})
      @hotspring = Hotspring.find_or_initialize_by(read(result[:hotels].first))
    end
  end
  
  def set_review
    @review = Review.find_by(id: params[:id])
  end

  def correct_user
    unless current_user == @review.user
      flash[:danger] = "不正なアクセスです。"
      redirect_back(fallback_location: root_path)
    end
  end  
end
