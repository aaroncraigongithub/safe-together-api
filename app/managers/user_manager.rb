# frozen_string_literal:true
class UserManager
  class TokenAlreadyUsed < StandardError; end

  def self.create(email:, password:)
    user = User.create!(
      email:    email,
      password: password,
      token:    SecureRandom.hex(32)
    )

    ConfirmUserMailWorker.perform_async user.id

    user.token
  end

  def self.confirm(token)
    user = User.find_by confirm_token: token

    raise ActiveRecord::RecordNotFound if user.nil?
    raise TokenAlreadyUsed unless user.confirmed_at.nil?

    user.confirmed_at = Time.zone.now
    user.save!
  end
end
