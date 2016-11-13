# frozen_string_literal:true
require 'rails_helper'

RSpec.describe V1::AlertsController, type: :controller do
  describe 'POST /alerts' do
    it_behaves_like 'an authenticated endpoint', :create, :post

    context 'given a confirmed user' do
      include_context 'an authenticated user', :user_with_friends

      before do
        expect(AlertManager).to receive(:create)
          .with(current_user.id)

        process :create, method: :post
      end

      it_behaves_like 'a 200 response'
    end

    context 'given an unconfirmed user' do
      include_context 'an authenticated user', :user_with_friends

      before do
        expect(AlertManager).to receive(:create)
          .with(current_user.id)
          .and_raise(AlertManager::ConfirmedUserRequired)

        process :create, method: :post
      end

      it_behaves_like 'a 422 response'
    end
  end
end
