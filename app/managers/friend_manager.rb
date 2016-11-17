# frozen_string_literal:true
class FriendManager
  class ConfirmedUserRequired < StandardError; end
  class EmailLimitReached < StandardError; end

  def self.confirm(token)
    friend = Friend.find_by invite_token: token
    raise ActiveRecord::RecordNotFound if friend.nil?

    friend.confirmed_at = Time.zone.now
    friend.save!
  end

  def self.invite(user_id, emails)
    raise EmailLimitReached if emails.count > 20

    user = User.find user_id
    raise ConfirmedUserRequired if user.confirmed_at.nil?

    emails.map do |email|
      invite_friend user, email
    end
  end

  def self.invite_friend(user, email)
    friend = create_friend user, email
    InviteFriendMailWorker.perform_async friend.id

    friend
  end

  def self.create_friend(user, email)
    friend_user = User.find_by email: email
    if friend_user.nil?
      friend_user = User.create! email: email, password: SecureRandom.hex(6)
    end

    Friend.create! user: user, friend_id: friend_user.id
  end
end
