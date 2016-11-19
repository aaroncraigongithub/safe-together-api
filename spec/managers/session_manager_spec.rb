# frozen_string_literal:true
require 'rails_helper'

RSpec.describe SessionManager do
  describe '#create' do
    let(:create_session) { described_class.create(email, password) }
    let(:password)       { Faker::Lorem.characters 10 }
    let(:email)          { Faker::Internet.email }
    let(:user)           { create(:user, password: password) }

    context 'given a valid email/password' do
      let(:email) { user.email }

      it 'returns the user' do
        expect(create_session.token).to eq user.reload.token
      end

      it 'creates the user token' do
        expect{ create_session }.to change{ user.reload.token }
      end
    end

    context 'given an invalid email/password' do
      it 'raises SessionManager::InvalidLogin' do
        expect { create_session }.to raise_error(SessionManager::InvalidLogin)
      end
    end

    context 'given a capital letter in the input email' do
      let(:email) { user.email.capitalize }

      it 'validates anyway' do
        expect(create_session.token).to eq user.reload.token
      end
    end

    context 'given a capital letter in the user email' do
      let(:email) { user.email }
      let(:user) do
        create(:user,
               password: password,
               email: Faker::Internet.email.capitalize)
      end

      it 'validates anyway' do
        expect(create_session.token).to eq user.reload.token
      end
    end
  end
end
