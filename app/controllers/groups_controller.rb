class GroupsController < ApplicationController

  def show
    @group = Group.find(params[:id])
    @owner = User.find(@group.owner_id)
    @members = @group.users
  end

  def index
    @groups = Group.all
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    @groups = Group.all
    if @group.save
      user = User.find(@group.owner_id)
      user.join(@group)
      redirect_to groups_path, notice: "You have created group successfully."
    else
      render 'new'
    end
  end

  def edit
    @group = Group.find(params[:id])
    redirect_to groups_path unless current_user.owned?(@group)
  end

  def update
    @group = Group.find(params[:id])
    if @group.update(group_params)
      redirect_to groups_path, notice: 'You habe updated group successfully.'
    else
      render 'edit'
    end
  end

  def sent_mail_new
    @group = Group.find(params[:group_id])
  end

  def sent_mail_create
    @title = params[:title]
    @content = params[:content]
    @group = Group.find(params[:group_id])
    users = @group.users
    users.each do |user|
      @user = user
      UserMailer.group_notice(@user, @group, @title, @content).deliver_now
    end

  end

  private

    def group_params
      params.require(:group).permit(:name, :introduction, :image)
    end

end
