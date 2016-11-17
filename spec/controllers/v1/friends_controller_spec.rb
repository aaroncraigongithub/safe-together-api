# frozen_string_literal: true
require 'rails_helper'

RSpec.describe V1::FriendsController do
  describe 'POST /friends/invite' do
    it_behaves_like 'an authenticated endpoint', :invite, :post

    context 'given an authenticated user' do
      include_context 'an authenticated user'
      include_context 'a JSON payload'

      let(:emails) { [Faker::Internet.email] }
      let(:new_friend) do
        u = create(:user, email: emails.first)

        create(:friend, user_id: current_user.id, friend: u)
      end

      before do
        expect(FriendManager).to receive(:invite)
          .with(current_user.id, emails)
          .and_return([new_friend])

        process :invite, method: :post, params: { emails: emails }
      end

      it_behaves_like 'a 200 response'

      it 'returns the new friend records' do
        expect(payload['data'].first['id']).to eq new_friend.uuid
      end
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
