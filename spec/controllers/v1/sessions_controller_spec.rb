# frozen_string_literal: true
require 'rails_helper'

RSpec.describe V1::SessionsController do
  describe 'POST /sessions' do
    include_context 'a JSON payload'

    let(:user)      { create(:authed_user) }
    let(:email)     { user.email }
    let(:password)  { user.password }
    let(:token)     { user.token }

    before do
      if defined? error
        expect(SessionManager).to receive(:create)
          .with(email, password)
          .and_raise(error)
      else
        expect(SessionManager).to receive(:create)
          .with(email, password)
          .and_return(user)
      end

      process :create, method: :post, params: {
        email:    email,
        password: password
      }
    end

    context 'given a correct username/password' do
      it_behaves_like 'a 200 response'

      it 'returns the user object' do
        expect(payload['data']['id']).to eq user.uuid
      end

      it 'returns the access token' do
        expect(payload['data']['attributes']['token']).to eq token
      end
    end

    context 'given an incorrect username/password' do
      let(:error) { SessionManager::InvalidLogin }

      it_behaves_like 'a 422 response'
    end
  end
end
