require 'rails_helper'

RSpec.describe Result, type: :model do
  let(:result) { create :result }

  describe 'バリデーション確認' do
    it '各カラムに適正な値があればバリデーションが通ること' do
      expect(result).to be_valid
    end

    it 'scoreの値がなければバリデーションが通らないこと' do
      result = build(:result, score: nil)
      expect(result.valid?).to be false
      expect(result.errors[:score]).to include("を入力してください")
    end

    it 'calmの値がなければバリデーションが通らないこと' do
      result = build(:result, calm: nil)
      expect(result.valid?).to be false
      expect(result.errors[:calm]).to include("を入力してください")
    end

    it 'angerの値がなければバリデーションが通らないこと' do
      result = build(:result, anger: nil)
      expect(result.valid?).to be false
      expect(result.errors[:anger]).to include("を入力してください")
    end

    it 'joyの値がなければバリデーションが通らないこと' do
      result = build(:result, joy: nil)
      expect(result.valid?).to be false
      expect(result.errors[:joy]).to include("を入力してください")
    end

    it 'sorrowの値がなければバリデーションが通らないこと' do
      result = build(:result, sorrow: nil)
      expect(result.valid?).to be false
      expect(result.errors[:sorrow]).to include("を入力してください")
    end

    it 'energyの値がなければバリデーションが通らないこと' do
      result = build(:result, energy: nil)
      expect(result.valid?).to be false
      expect(result.errors[:energy]).to include("を入力してください")
    end
  end
end
