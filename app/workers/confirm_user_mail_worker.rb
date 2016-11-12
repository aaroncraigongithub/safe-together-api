# frozen_string_literal:true
class ConfirmUserMailWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find user_id
    return unless user.confirmed_at.nil?

    ConfirmUserMailer.send_mail(user.id).deliver_now
  end
end
