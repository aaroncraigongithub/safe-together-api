# frozen_string_literal:true
require 'rails_helper'

RSpec.describe PusherAlertWorker do
  describe '.perform_async' do
    let(:user)   { create(:user_with_alert) }
    let(:alert)  { user.alert }
    let(:friend) { user.friends.first }
    let(:message) do
      "#{user.name} needs your help.  Please call immediately."
    end
    let(:payload) do
      {
        message: message,
        apns: {
          aps: {
            alert: {
              body: message
            }
          }
        },
        fcm: {
          notification: {
            title: 'Stronger Together',
            body:  message
          }
        }
      }
    end

    before do
      expect(Pusher).to receive(:trigger)
        .with(
          friend.uuid,
          'alert',
          payload
        )
    end

    it 'sends the message' do
      expect {
        described_class.new.perform alert.id
      }.not_to raise_error
    end
  end
end
