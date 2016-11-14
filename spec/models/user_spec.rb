# frozen_string_literal:true
require 'rails_helper'

RSpec.describe User do
  describe '.token' do
    let(:user) { create(:user, confirm_token: nil) }

    it 'creates a confirm_token' do
      expect(user.confirm_token).not_to be nil
    end
  end

  describe '.name' do
    context 'given a user with no name' do
      let(:user)  { create(:user, name: nil) }
      let(:name)  { user.email.split('@').first }

      it 'derives a name from the email address' do
        expect(user.name).to eq name
      end
    end
  end

  describe '.alert' do
    context 'given no alert' do
      let(:user) { create(:user) }

      it 'returns nil' do
        expect(user.alert).to be nil
      end
    end

    context 'given an active alert' do
      let(:alert) { create(:alert) }
      let(:user)  { alert.user }

      it 'returns the alert' do
        expect(user.alert.id).to eq alert.id
      end
    end

    context 'given an inactive alert' do
      let(:user) { create(:inactive_alert).user }

      it 'returns nil' do
        expect(user.alert).to be nil
      end
    end
  end
end
