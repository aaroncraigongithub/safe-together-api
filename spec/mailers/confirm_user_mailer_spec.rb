# frozen_string_literal:true
require 'rails_helper'

RSpec.describe ConfirmUserMailer do
  let(:user)  { create(:user) }
  let(:email) { described_class.send_mail(user.id) }

  it 'sets the correct to address' do
    expect(email).to deliver_to(user.email)
  end

  it 'contains the confirm url' do
    expect(email).to have_body_text(user.confirm_token)
  end

  it 'contains the correct subject' do
    expect(email).to have_subject(/Confirm your Stronger Together account/)
  end
end
