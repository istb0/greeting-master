require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create :user }

  describe 'バリデーション確認' do
    it 'ニックネーム・メールアドレス・パスワードがあれば登録できること' do
      expect(user).to be_valid
    end

    it 'ニックネームがなければ登録できないこと' do
      user = build(:user, name: nil)
      expect(user.valid?).to be false
      expect(user.errors[:name]).to include("を入力してください")
    end

    it 'ニックネームは11文字以上で登録できないこと' do
      user = build(:user, name: "more_than_eleven")
      expect(user.valid?).to be false
      expect(user.errors[:name]).to include("は10文字以内で入力してください")
    end

    it 'メールアドレスがなければ登録できないこと' do
      user = build(:user, email: nil)
      expect(user.valid?).to be false
      expect(user.errors[:email]).to include("を入力してください")
    end

    it '重複するメールアドレスでは登録できないこと' do
      duplicated_user = build(:user, email: user.email)
      expect(duplicated_user.valid?).to be false
      expect(duplicated_user.errors[:email]).to include("はすでに存在します")
    end

    it 'パスワードがなければ登録できないこと' do
      user = build(:user, password: nil)
      expect(user.valid?).to be false
      expect(user.errors[:password]).to include("は3文字以上で入力してください")
    end

    it 'パスワードは2文字以下で登録できないこと' do
      user = build(:user, password: "pw")
      expect(user.valid?).to be false
      expect(user.errors[:password]).to include("は3文字以上で入力してください")
    end
 
    it 'パスワード確認がなければ登録できないこと' do
      user = build(:user, password_confirmation: nil)
      expect(user.valid?).to be false
      expect(user.errors[:password_confirmation]).to include("を入力してください")
    end
  end
end
