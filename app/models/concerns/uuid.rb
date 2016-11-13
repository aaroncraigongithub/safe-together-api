# frozen_string_literal: true
module Uuid
  extend ActiveSupport::Concern

  included do
    before_save :ensure_uuid
  end

  protected

  def ensure_uuid
    self.uuid = SecureRandom.uuid if uuid.blank?
  end
end
