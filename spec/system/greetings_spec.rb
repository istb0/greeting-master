require 'rails_helper'

RSpec.describe 'Greetings', type: :system do
  let!(:greeting) { create :greeting }

  before { visit greetings_path }

  describe '挨拶選択ページ' do
    it '挨拶文が表示されること' do
      expect(page).to have_content('phrase')
    end

    it '挨拶文を選択すると録音ページに遷移すること' do
      click_link 'phrase'
      expect(page).to have_current_path(greeting_path(greeting))
    end
  end
end
