# frozen_string_literal: true
require 'rails_helper'

RSpec.describe V1::UsersController do
  describe 'POST /users' do
    include_context 'a JSON payload'

    let(:email)    { Faker::Internet.email }
    let(:password) { Faker::Lorem.characters(10) }
    let(:token)    { SecureRandom.hex }

    before do
      expect(UserManager).to receive(:create)
        .with(
          email:    email,
          password: password
        )
        .and_return(token)

      process :create, method: :post, params: {
        email: email, password: password
      }
    end

    it_behaves_like 'a 200 response'

    it 'returns the user auth token' do
      expect(payload[:token]).to eq token
    end
  end

  describe 'GET /users/confirm/:token' do
    let(:token) { SecureRandom.hex }
    let(:error) { nil }

    before do
      if error
        expect(UserManager).to receive(:confirm)
          .with(token)
          .and_raise(error)
      else
        expect(UserManager).to receive(:confirm)
          .with(token)
          .and_return(true)
      end

      process :confirm, method: :get, params: { token: token }
    end

    context 'given a valid token' do
      it_behaves_like 'a 200 response'
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
