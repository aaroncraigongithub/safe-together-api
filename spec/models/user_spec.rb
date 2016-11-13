# frozen_string_literal:true
require 'rails_helper'

RSpec.describe User do
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
