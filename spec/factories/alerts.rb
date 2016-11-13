# frozen_string_literal:true
FactoryGirl.define do
  factory :alert do
    association :user, factory: :user_with_friends

    factory :inactive_alert do
      deactivated_at { Time.zone.now - 5.minutes }
    end
  end
end
