# frozen_string_literal:true
require 'rails_helper'

RSpec.describe AddFriendMailer do
  let(:friend) { create(:friend) }
  let(:email)  { described_class.send_mail(friend.id) }

  it 'sets the correct to address' do
    expect(email).to deliver_to(friend.friend.email)
  end

  it 'contains the confirm url' do
    expect(email).to have_body_text(friend.invite_token)
  end

  it 'contains the correct subject' do
    expect(email).to have_subject(
      /#{friend.user.name} wants to add you on Stronger Together/
    )
  end
end
