# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Friend do
  describe '.invite_token' do
    let(:friend) { create(:friend) }

    it 'creates an invite token on save' do
      expect(friend.invite_token).not_to be nil
    end
  end
end
