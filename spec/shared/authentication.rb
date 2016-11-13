# frozen_string_literal: true
RSpec.shared_context 'an authenticated user' do
  let(:current_user) { create(:authed_user) }

  before do
    request.env['HTTP_AUTHORIZATION'] = current_user.token
  end
end

RSpec.shared_context 'an authenticated endpoint' do |action, method, p = {}|
  context 'given an unauthenticated user' do
    before do
      process action, method: method, params: p
    end

    it_behaves_like 'a 403 response'
  end
end
