# frozen_string_literal:true
require 'rails_helper'

RSpec.describe AddFriendMailWorker do
  describe '.perform' do
    let(:friend) { create(:friend) }

    before do
      described_class.new.perform friend.id
    end

    it 'delivers the mail' do
      expect(ActionMailer::Base.deliveries.count).to eq 1
    end
  end
end
