FactoryBot.define do
  factory :user do
    name { 'テストユーザー' }
    sequence(:email) {|n| "test#{n}@t#{n}.com" }
    password { 'password' }
  end
end