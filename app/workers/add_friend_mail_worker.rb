# frozen_string_literal:true
class AddFriendMailWorker
  include Sidekiq::Worker

  def perform(friend_id)
    AddFriendMailer.send_mail(friend_id).deliver_now
  end
end
