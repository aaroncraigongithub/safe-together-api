# frozen_string_literal: true
RSpec.shared_context 'an authenticated user' do |f = :authed_user|
  let(:current_user) do
    u = create(f)

    if u.token.nil?
      u.token = SecureRandom.hex
      u.save!
    end

    u
  end

  before do
    request.env['HTTP_AUTHORIZATION'] = "Bearer #{current_user.token}"
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
