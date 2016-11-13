# frozen_string_literal: true
class Friend < ApplicationRecord
  include Uuid

  belongs_to :user
  belongs_to :friend, class_name: 'User'

  before_save :ensure_token

  protected

  def ensure_token
    return if invite_token.present?

    self.invite_token = SecureRandom.hex
  end
end
