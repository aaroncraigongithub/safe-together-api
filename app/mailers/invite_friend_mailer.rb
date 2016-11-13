# frozen_string_literal:true
class InviteFriendMailer < ApplicationMailer
  def send_mail(friend_id)
    @friend = Friend.find friend_id

    mail(
      to:      @friend.friend.email,
      subject: "#{@friend.user.name} has invited you to join Stronger Together"
    )
  end
end
