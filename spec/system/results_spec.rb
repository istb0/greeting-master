require 'rails_helper'

RSpec.describe 'Results', type: :system do
  let(:result) { create :result, score: 10, anger: 50 }
  let!(:feedback) { create :feedback, max_score: 20, emotion_type: 1 }

  describe '結果表示' do
    let(:api_limit) { create :result, score: -999 }

    context '正常に録音が完了した場合' do
      it '総合スコア、フィードバックが表示されること' do
        visit result_path(result)
        expect(page).to have_content(result.score)
        expect(page).to have_content(feedback.comment)
      end
    end

    context 'API利用上限に達した場合' do
      it '利用上限に達した旨の通知が表示されること' do
        visit result_path(api_limit)
        expect(page).to have_content('感情分析機能は停止しております。')
      end
    end
  end

  describe 'ツイートリンク' do
    it 'ツイートボタンを押すと、ツイッターシェアができること' do
      visit result_path(result)
      find('.btn-primary').click
      switch_to_window(windows.last)
      expect(current_host).to eq('https://twitter.com')
    end
  end

  describe 'ユーザー登録リンク' do
    let(:user) { create(:user) }

    context 'ログインユーザーの場合' do
      it 'ユーザー登録ボタンが表示されないこと' do
        login_as(user)
        visit result_path(result)
        expect(page).not_to have_css '.btn-secondary'
      end
    end

    context '非ログインユーザーの場合' do
      before { visit result_path(result) }

      it 'ユーザー登録ボタンが表示されること' do
        expect(page).to have_css '.btn-secondary'
      end

      it 'ユーザー登録ボタンを押すとユーザー登録ページに遷移すること' do
        find('.btn-secondary').click
        expect(page).to have_current_path("/users/new?result_id=#{result.id}")
      end
    end
  end
end
