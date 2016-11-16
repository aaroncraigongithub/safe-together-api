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

      factory :authed_user do
        token { SecureRandom.hex }
      end

      factory :user_with_friends do
        after(:create) do |u, _e|
          create(:confirmed_friend, user: u)
        end

        factory :user_with_alert do
          after(:create) do |u, _e|
            create(:alert, user: u)
          end
        end
      end
    end
  end
end
