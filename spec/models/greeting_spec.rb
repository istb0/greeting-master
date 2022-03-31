require 'rails_helper'

RSpec.describe Greeting, type: :model do
  let(:greeting) { create :greeting }

  describe 'バリデーション確認' do
    it '各カラムに適正な値があればバリデーションが通ること' do
      expect(greeting).to be_valid
    end

    it 'phraseの値がなければバリデーションが通らないこと' do
      greeting = build(:greeting, phrase: nil)
      expect(greeting.valid?).to be false
      expect(greeting.errors[:phrase]).to include("を入力してください")
    end
  end
end
