# frozen_string_literal: true
require 'rails_helper'

RSpec.describe V1::FriendsController do
  describe 'POST /friends/add' do
    it_behaves_like 'an authenticated endpoint', :add, :post

    context 'given an authenticated user' do
      include_context 'an authenticated user'
      let(:user_ids) { [rand(1..1000).to_s] }

      before do
        expect(UserManager).to receive(:add_friends)
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
        expect(UserManager).to receive(:invite_friends)
          .with(current_user.id, emails)

        process :invite, method: :post, params: { emails: emails }
      end

      it_behaves_like 'a 200 response'
    end
  end
end
