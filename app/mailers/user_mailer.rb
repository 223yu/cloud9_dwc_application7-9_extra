class UserMailer < ApplicationMailer

  def group_notice(user, group, title, content)
    @user = user
    @group = group
    @title = title
    @content = content
    mail to: user.email, subject: 'Notice an Event'
  end
end
