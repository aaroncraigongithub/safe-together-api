# frozen_string_literal:true
require 'rails_helper'

RSpec.describe FriendManager do
  describe '#confirm' do
    let(:friend) { create(:friend) }

    context 'given an existing token' do
      before do
        described_class.confirm friend.invite_token
      end

      it 'sets the confirmed_at field' do
        expect(friend.reload.confirmed_at).not_to be nil
      end
    end

    context 'given a non-existant token' do
      it 'raises an ActiveRecord::RecordNotFound error' do
        expect {
          described_class.confirm SecureRandom.hex
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '#invite' do
    let(:emails)     { [Faker::Internet.email] }
    let(:user)       { create(:confirmed_user) }
    let(:friend)     { Friend.find_by user_id: user.id }
    let(:new_friend) { described_class.invite(user.id, emails).first }

    context 'given a confirmed user' do
      before do
        expect(new_friend).to be_a_kind_of(Friend)
      end

      it 'queues the email worker' do
        expect(InviteFriendMailWorker.jobs.size).to eq 1
      end

      it 'queues the right params' do
        expect(InviteFriendMailWorker.jobs.first['args'])
          .to eq [friend.id]
      end

      it 'creates the Friend record' do
        expect(friend).not_to be nil
      end
    end

    context 'given an unconfirmed user' do
      let(:user) { create(:user) }

      it 'raises a FriendManager::ConfirmedUserRequired error' do
        expect {
          described_class.invite user.id, emails
        }.to raise_error(FriendManager::ConfirmedUserRequired)
      end
    end

    context 'given more than 20 emails' do
      let(:emails) { Array.new 21, Faker::Internet.email }

      it 'raises a FriendManager::EmailLimitReached error' do
        expect {
          described_class.invite user.id, emails
        }.to raise_error(FriendManager::EmailLimitReached)
      end
    end
  end
end
