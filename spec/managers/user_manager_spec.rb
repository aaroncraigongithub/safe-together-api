# frozen_string_literal:true
require 'rails_helper'

RSpec.describe UserManager do
  describe '#create' do
    let(:email)    { Faker::Internet.email }
    let(:password) { Faker::Lorem.characters(10) }
    let(:user)     { User.find_by(email: email) }

    context 'given a new email' do
      before do
        expect(
          described_class.create(email: email, password: password).token
        ).to eq user.token
      end

      it 'creates the user' do
        expect(user).not_to be nil
      end

      it 'stores the token' do
        expect(user.token).not_to be nil
      end

      it 'queues a mail worker' do
        expect(ConfirmUserMailWorker.jobs.size).to eq 1
      end
    end

    context 'given an existing email' do
      let(:email) { create(:user).email }

      it 'throws an error' do
        expect{
          described_class.create(email: email, password: password)
        }.to raise_error(ActiveRecord::RecordNotUnique)
      end
    end
  end

  describe '#confirm' do
    let(:user)  { create(:user) }
    let(:token) { user.confirm_token }

    context 'given a valid token' do
      before do
        expect(described_class.confirm(token).id).to eq user.id
      end

      it 'confirms the user' do
        expect(user.reload.confirmed_at).not_to be nil
      end
    end

    context 'given an invalid token' do
      let(:token) { SecureRandom.hex }

      it 'raises an ActiveRecord::RecordNotFound error' do
        expect {
          described_class.confirm token
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'given a used token' do
      let(:user) { create(:confirmed_user) }

      it 'raises an UserManager::TokenAlreadyUsed error' do
        expect {
          described_class.confirm token
        }.to raise_error(UserManager::TokenAlreadyUsed)
      end
    end
  end
end
