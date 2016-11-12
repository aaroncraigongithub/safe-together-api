# frozen_string_literal:true
FactoryGirl.define do
  factory :user do
    email                 { Faker::Internet.email }
    name                  { Faker::Name.name }
    confirm_token         { SecureRandom.hex }
    password              { Faker::Lorem.characters(10) }
    password_confirmation { password }

    factory :confirmed_user do
      confirmed_at { Time.zone.now - 1.day }
    end

    factory :authed_user do
      token { SecureRandom.hex }
    end
  end
end
