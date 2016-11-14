# frozen_string_literal: true
require 'rails_helper'

RSpec.describe V1::SessionsController do
  describe 'POST /sessions' do
    include_context 'a JSON payload'

    let(:email)     { Faker::Internet.email }
    let(:password)  { Faker::Lorem.characters(10) }
    let(:token)     { SecureRandom.hex }

    before do
      if defined? error
        expect(SessionManager).to receive(:create)
          .with(email, password)
          .and_raise(error)
      else
        expect(SessionManager).to receive(:create)
          .with(email, password)
          .and_return(token)
      end
      process :create, method: :post, params: {
        email:    email,
        password: password
      }
    end

    context 'given a correct username/password' do
      it_behaves_like 'a 200 response'

      it 'returns the session token' do
        expect(payload['token']).to eq token
      end
    end

    context 'given an incorrect username/password' do
      let(:error) { SessionManager::InvalidLogin }

      it_behaves_like 'a 422 response'
    end
  end
end
