# frozen_string_literal: true
FactoryGirl.define do
  factory :friend do
    user         { create(:confirmed_user) }
    friend_id    { create(:confirmed_user).id }

    factory :confirmed_friend do
      confirmed_at { Time.zone.now - 5.minutes }
    end
  end
end
