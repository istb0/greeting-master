require 'rails_helper'

RSpec.describe 'Users', type: :system do
  describe 'ユーザー登録' do
    before do
      visit new_user_path
    end

    context '期待する値が入力される場合' do
      it 'ユーザー登録が成功し、TOPページに遷移すること' do
        fill_in 'ニックネーム', with: 'user'
        fill_in 'メールアドレス', with: 'user@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード確認', with: 'password'
        click_button '登録'
        expect(User.count).to eq 1
        expect(page).to have_content('ユーザー登録に成功しました')
        expect(page).to have_current_path(root_path)
      end
    end

    context '期待する値が入力されない場合' do
      it 'ニックネームがなければ登録に失敗すること' do
        fill_in 'メールアドレス', with: 'user@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード確認', with: 'password'
        click_button '登録'
        expect(User.count).to eq 0
        expect(page).to have_content('ユーザー登録に失敗しました')
      end
    end
  end

  describe 'マイページ' do
    let(:user) { create(:user) }

    before { login_as(user) }

    context '期待する値が入力される場合' do
      it 'ユーザー登録情報更新が成功する' do
        visit edit_user_path(user)
        fill_in 'ニックネーム', with: 'new_name'
        fill_in 'メールアドレス', with: 'new_email@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード確認', with: 'password'
        click_button '更新'
        expect(page).to have_content('登録情報を更新しました')
        expect(page).to have_field 'ニックネーム', with: 'new_name'
      end
    end

    context '期待する値が入力されない場合' do
      it 'ニックネームが空欄だと更新に失敗する' do
        visit edit_user_path(user)
        fill_in 'ニックネーム', with: ''
        fill_in 'メールアドレス', with: 'new_email@example.com'
        fill_in 'パスワード', with: 'new_password'
        fill_in 'パスワード確認', with: 'new_password'
        click_button '更新'
        expect(page).to have_content('登録情報の更新に失敗しました')
        expect(page).not_to have_content('new_name')
      end
    end
  end
end
