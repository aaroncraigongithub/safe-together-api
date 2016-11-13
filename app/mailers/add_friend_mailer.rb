# frozen_string_literal:true
class AddFriendMailer < ApplicationMailer
  def send_mail(friend_id)
    @friend = Friend.find friend_id

    mail(
      to:      @friend.friend.email,
      subject: "#{@friend.user.name} wants to add you on Stronger Together"
    )
  end
end
