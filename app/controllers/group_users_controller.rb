class GroupUsersController < ApplicationController

  def create
    @group = Group.find(params[:group_id])
    current_user.join(@group)
    @members = @group.users
  end

  def destroy
    @group = Group.find(params[:id])
    current_user.leave_group(@group)
    @members = @group.users
  end
end
