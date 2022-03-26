FactoryBot.define do
  factory :feedback do
    comment { 'comment' }
    max_score { [20, 40, 60, 80, 100][rand(0..4)] }
    emotion_type { rand(0..4) }
  end
end
