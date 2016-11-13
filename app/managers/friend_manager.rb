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

  def self.add(user_id, user_ids)
    user = User.find user_id
    raise ConfirmedUserRequired if user.confirmed_at.nil?

    user_ids.each do |id|
      add_friend user, id
    end
  end

  def self.invite(user_id, emails)
    raise EmailLimitReached if emails.count > 20

    user = User.find user_id
    raise ConfirmedUserRequired if user.confirmed_at.nil?

    emails.each do |email|
      invite_friend user, email
    end
  end

  def self.add_friend(user, friend_id)
    friend = Friend.create! user: user, friend_id: friend_id
    AddFriendMailWorker.perform_async friend.id
  end

  def self.invite_friend(user, email)
    friend = create_friend user, email
    InviteFriendMailWorker.perform_async friend.id
  end

  def self.create_friend(user, email)
    friend_user = User.create! email: email, password: SecureRandom.hex(6)
    friend_user.confirm_token = UserManager.generate_token
    friend_user.save!

    Friend.create! user: user, friend_id: friend_user.id
  end
end
