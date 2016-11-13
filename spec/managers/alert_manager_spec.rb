# frozen_string_literal:true
require 'rails_helper'

RSpec.describe AlertManager do
  describe '#create' do
    let(:user) { create(:user_with_friends) }

    context 'given a confirmed user' do
      before do
        described_class.create user.id
      end

      it 'creates an alert' do
        expect(user.alert).not_to be nil
      end

      it 'queues a Pusher worker' do
        expect(PusherAlertWorker.jobs.first['args']).to eq [user.alert.id]
      end
    end

    context 'given an unconfirmed user' do
      let(:user) { create(:user) }

      it 'raises an AlertManager::ConfirmedUserRequired error' do
        expect {
          described_class.create user.id
        }.to raise_error(AlertManager::ConfirmedUserRequired)
      end
    end

    context 'given an ongoing alert' do
      let(:user) { create(:user_with_alert) }

      before do
        described_class.create user.id
      end

      it 'raises the alert level' do
        expect(user.alert.level).to eq 1
      end

      it 'queues a Pusher worker' do
        expect(PusherAlertLevelWorker.jobs.first['args']).to eq [user.alert.id]
      end
    end
  end
end
