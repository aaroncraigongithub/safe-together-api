# frozen_string_literal: true
require 'rails_helper'

RSpec.describe V1::FriendsController do
  describe 'POST /friends/add' do
    it_behaves_like 'an authenticated endpoint', :add, :post

    context 'given an authenticated user' do
      include_context 'an authenticated user'
      let(:user_ids) { [rand(1..1000).to_s] }

      before do
        expect(FriendManager).to receive(:add)
          .with(current_user.id, user_ids)

        process :add, method: :post, params: { user_ids: user_ids }
      end

      it_behaves_like 'a 200 response'
    end
  end

  describe 'POST /friends/invite' do
    it_behaves_like 'an authenticated endpoint', :invite, :post

    context 'given an authenticated user' do
      include_context 'an authenticated user'
      let(:emails) { [Faker::Internet.email] }

      before do
        expect(FriendManager).to receive(:invite)
          .with(current_user.id, emails)

        process :invite, method: :post, params: { emails: emails }
      end

      it_behaves_like 'a 200 response'
    end
  end

  describe 'PUT /friends/confirm/:token' do
    it_behaves_like 'an authenticated endpoint', :confirm, :put, token: 1

    context 'given a known token' do
      include_context 'an authenticated user'
      let(:token) { SecureRandom.hex }

      before do
        expect(FriendManager).to receive(:confirm)
          .with(token)

        process :confirm, method: :put, params: { token: token }
      end

      it_behaves_like 'a 200 response'
    end
  end

  describe 'GET /friends' do
    it_behaves_like 'an authenticated endpoint', :show, :get

    context 'given a user with friends' do
      include_context 'an authenticated user', :user_with_friends
      include_context 'a JSON payload'

      before do
        process :show, method: :get
      end

      it_behaves_like 'a 200 response'

      it 'returns the list of friends' do
        expect(payload['data'].first['id'])
          .to eq current_user.friends.first.uuid
      end
    end
  end
end
