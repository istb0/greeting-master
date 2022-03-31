require 'rails_helper'

RSpec.describe Feedback, type: :model do
  describe 'バリデーション確認' do
    it '各カラムに適正な値があればバリデーションが通ること' do
      feedback = build(:feedback)
      expect(feedback).to be_valid
    end

    it 'commentの値がなければバリデーションが通らないこと' do
      feedback = build(:feedback, comment: nil)
      expect(feedback.valid?).to be false
      expect(feedback.errors[:comment]).to include("を入力してください")
    end
  end
end
