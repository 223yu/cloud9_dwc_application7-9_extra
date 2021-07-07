class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:update]

  def show
    @user = User.find(params[:id])
    @books = @user.books.sort { |a,b| b.a_week_favorited_count <=> a.a_week_favorited_count }
    @book = Book.new

    # 投稿数用
    @post_count = []
    (0..6).each do |n|
      @post_count.push(@user.post_count(n,n))
    end
    if @post_count[1] == 0
      @day_before_ratio = '-'
    else
      @day_before_ratio = @post_count[0]*100 / @post_count[1]
    end
    @post_count_this_week = @user.post_count(6,0)
    @post_count_last_week = @user.post_count(13,7)
    if @post_count_last_week == 0
      @week_before_ratio = '-'
    else
      @week_before_ratio = @post_count_this_week*100 / @post_count_last_week
    end
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
    redirect_to user_path(current_user) unless current_user == @user
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end

  def following
    @title = 'Follow'
    @users = User.find(params[:id]).following
    render 'follow'
  end

  def followers
    @title = 'Follower'
    @users = User.find(params[:id]).followers
    render 'follow'
  end

  private

    def user_params
      params.require(:user).permit(:name, :introduction, :profile_image)
    end

    def ensure_correct_user
      @user = User.find(params[:id])
      unless @user == current_user
        redirect_to user_path(current_user)
      end
    end
end
