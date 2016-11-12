# frozen_string_literal:true
require 'rails_helper'

RSpec.describe ConfirmUserMailWorker do
  describe '.perform' do
    let(:user) { create(:user) }

    before do
      described_class.new.perform user.id
    end

    context 'given an unconfirmed user' do
      it 'delivers the mail' do
        expect(ActionMailer::Base.deliveries.count).to eq 1
      end
    end

    context 'given a user that has already been confirmed' do
      let(:user) { create(:confirmed_user) }

      it 'does not deliver the mail' do
        expect(ActionMailer::Base.deliveries.count).to eq 0
      end
    end
  end
end
