# frozen_string_literal:true
class InviteFriendMailWorker
  include Sidekiq::Worker

  def perform(friend_id)
    InviteFriendMailer.send_mail(friend_id).deliver_now
  end
end
