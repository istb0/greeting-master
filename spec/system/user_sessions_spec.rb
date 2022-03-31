require 'rails_helper'

RSpec.describe 'UserSessions', type: :system do
  let(:user) { create(:user) }

  describe 'ログイン前' do
    context 'フォームの入力値が正常の場合' do
      it 'ログインが成功すること' do
        visit login_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: 'password'
        click_button 'ログイン'
        expect(page).to have_content 'ログインしました'
        expect(page).to have_current_path root_path
      end
    end

    context 'フォームが未入力の場合' do
      it 'ログインが失敗すること' do
        visit login_path
        fill_in 'メールアドレス', with: ''
        fill_in 'パスワード', with: 'pass'
        click_button 'ログイン'
        expect(page).to have_content 'ログインに失敗しました'
        expect(page).to have_current_path login_path
      end
    end
  end

  describe 'ログイン後' do
    it 'ログアウトボタンをクリックしてログアウトが成功すること' do
      login_as(user)
      click_link 'ログアウト'
      expect(page).to have_content 'ログアウトしました'
      expect(page).to have_current_path root_path
    end
  end
end
