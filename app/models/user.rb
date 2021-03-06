# frozen_string_literal:true
class User < ApplicationRecord
  include Uuid

  has_many :alerts
  has_many :friends

  has_secure_password

  before_save :ensure_name
  before_save :ensure_confirm_token

  def alert
    alerts.find_by deactivated_at: nil
  end

  def all_friends
    Friend.where('friend_id = ? OR user_id = ?', id, id)
  end

  def confirmed_friends
    all_friends.where('confirmed_at IS NOT NULL')
  end

  protected

  def ensure_name
    return if name.present?

    self.name = email.split('@').first
  end

  def ensure_confirm_token
    return if confirm_token.present?

    self.confirm_token = SecureRandom.hex 32
  end
end
