# frozen_string_literal:true
class UserManager
  class TokenAlreadyUsed < StandardError; end
  class ConfirmedUserRequired < StandardError; end
  class EmailLimitReached < StandardError; end

  def self.create(email:, password:)
    user = User.create! email: email, password: password

    user.confirm_token = generate_token
    user.save!

    ConfirmUserMailWorker.perform_async user.id

    user.confirm_token
  end

  def self.confirm(token)
    user = User.find_by confirm_token: token

    raise ActiveRecord::RecordNotFound if user.nil?
    raise TokenAlreadyUsed unless user.confirmed_at.nil?

    user.confirmed_at = Time.zone.now
    user.save!
  end

  def self.add_friends(user_id, user_ids)

  end

  def self.invite_friends(user_id, emails)
    raise EmailLimitReached if emails.count > 20

    user = User.find user_id
    raise ConfirmedUserRequired if user.confirmed_at.nil?

    emails.each do |email|
      InviteFriendMailWorker.perform_async user_id, email
    end
  end

  def self.generate_token
    runaway = 100
    User.transaction do
      while runaway.positive?
        token = SecureRandom.hex(16)
        return token if User.find_by(confirm_token: token).nil?

        runaway -= 1
      end
    end
  end
end
