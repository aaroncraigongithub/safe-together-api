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

  describe '.confirmed_friends' do
    context 'given some unconfirmed friends' do
      let(:user) do
        u = create(:confirmed_user)
        create(:friend, user: u)

        u
      end

      it 'returns 0' do
        expect(user.confirmed_friends.count).to eq 0
      end
    end

    context 'given some unconfirmed invitations' do
      let(:user) do
        u = create(:confirmed_user)
        create(:friend, friend: u)

        u
      end

      it 'returns 0' do
        expect(user.confirmed_friends.count).to eq 0
      end
    end

    context 'given confirmed friends' do
      let(:user) do
        u = create(:confirmed_user)
        create(:confirmed_friend, user: u)

        u
      end

      it 'returns 1' do
        expect(user.confirmed_friends.count).to eq 1
      end
    end

    context 'given confirmed invitations' do
      let(:user) do
        u = create(:confirmed_user)
        create(:confirmed_friend, friend: u)

        u
      end

      it 'returns 1' do
        expect(user.confirmed_friends.count).to eq 1
      end
    end
  end
end
