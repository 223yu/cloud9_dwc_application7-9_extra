class UserChatsController < ApplicationController

  def index
    @user = User.find(params[:user_id])
    @chat_lists = current_user.chat_index(@user)
    @user_chat = UserChat.new
  end

  def create
    @user = User.find(params[:user_id])
    chat = UserChat.new(user_chat_params)
    chat.send_user_id = current_user.id
    chat.receive_user_id = @user.id
    chat.save
    @chat_lists = current_user.chat_index(@user)
  end

  private
    def user_chat_params
      params.require(:user_chat).permit(:content)
    end

end
