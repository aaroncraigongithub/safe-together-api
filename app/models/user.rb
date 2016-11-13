# frozen_string_literal:true
class User < ApplicationRecord
  include Uuid

  has_many :alerts
  has_many :friends

  has_secure_password

  def alert
    alerts.find_by deactivated_at: nil
  end
end
