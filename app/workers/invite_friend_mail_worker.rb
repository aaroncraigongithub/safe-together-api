# frozen_string_literal:true
class InviteFriendMailWorker
  include Sidekiq::Worker

  def perform(user_id, email)

  end
end
