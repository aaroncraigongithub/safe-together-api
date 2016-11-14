# frozen_string_literal: true
class SessionManager
  class SessionManager::InvalidLogin < StandardError; end

  def self.create(email, password)
    user = User.find_by email: email
    raise SessionManager::InvalidLogin if user.nil?
    raise SessionManager::InvalidLogin unless user.authenticate(password)

    user.token = SecureRandom.hex
    user.save!

    user.token
  end
end
