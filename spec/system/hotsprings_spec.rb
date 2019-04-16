require 'rails_helper'

describe '施設管理機能', type: :system do
  describe '一覧表示機能' do
    before do
      # ユーザーAを作成しておく
      user_a = FactoryBot.create(:user, name: 'ユーザーA', email: 'a@a.com')
      # 登録者がユーザーAである施設を作成しておく
      hotspring_a = FactoryBot.create(:hotspring)
      # 両者を紐付けるアソシエーションを作成する
      FactoryBot.create(:relationship, user: user_a, hotspring: hotspring_a)
    end
    
    context 'ユーザーAがログインしているとき' do
      before do
        # ユーザーAでログインする
        visit login_path
        fill_in 'メールアドレス', with: 'a@a.com'
        fill_in 'パスワード', with: 'password'
        click_button 'ログイン'
      end
      
      it 'ユーザーAが登録した施設が表示される' do
        # 作成済みの施設名称が画面上に表示されていることを確認'
        expect(page).to have_content 'テスト'
      end
    end
  end
end