FactoryBot.define do
  factory :review do
    title { 'テストのタイトル' }
    comment { 'テストのコメント' }
    satisfaction_degree { 5.0 }
    # visit_date { Date.today }
    user
  end
end