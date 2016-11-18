# frozen_string_literal: true
require 'rails_helper'

RSpec.describe V1::UsersController do
  include_context 'a JSON payload'

  describe 'GET /users' do
    it_behaves_like 'an authenticated endpoint', :show, :get

    context 'an authenticated user' do
      include_context 'an authenticated user'

      before do
        process :show, method: :get
      end

      it_behaves_like 'a 200 response'

      it 'returns the user data' do
        expect(payload['data']['id']).to eq current_user.uuid
      end
    end
  end

  describe 'POST /users' do
    let(:email)    { Faker::Internet.email }
    let(:password) { Faker::Lorem.characters(10) }
    let(:token)    { SecureRandom.hex }
    let(:user) do
      create(:user, token: token, password: password, email: email)
    end

    before do
      expect(UserManager).to receive(:create)
        .with(
          email:    email,
          password: password
        )
        .and_return(user)

      process :create, method: :post, params: {
        email: email, password: password
      }
    end

    it_behaves_like 'a 200 response'

    it 'returns the user record' do
      expect(payload['data']['id']).to eq user.uuid
    end

    it 'returns the user auth token' do
      expect(payload['data']['attributes']['token']).to eq user.token
    end
  end

  describe 'PUT /users/confirm/:token' do
    let(:user)  { create(:confirmed_user) }
    let(:token) { user.confirm_token }
    let(:error) { nil }

    before do
      if error
        expect(UserManager).to receive(:confirm)
          .with(token)
          .and_raise(error)
      else
        expect(UserManager).to receive(:confirm)
          .with(token)
          .and_return(user)
      end

      process :confirm, method: :put, params: { token: token }
    end

    context 'given a valid token' do
      it_behaves_like 'a 200 response'

      it 'returns the user object' do
        expect(payload['data']['id']).to eq user.uuid
      end
    end

    context 'given an invalid token' do
      let(:error) { ActiveRecord::RecordNotFound }

      it_behaves_like 'a 404 response'
    end

    context 'given a used token' do
      let(:error) { UserManager::TokenAlreadyUsed }

      it_behaves_like 'a 422 response'
    end
  end
end
