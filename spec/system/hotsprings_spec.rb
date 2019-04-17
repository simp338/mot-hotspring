require 'rails_helper'

describe '施設管理機能', type: :system do
  describe '一覧表示機能' do
      #ユーザーAを定義
      let(:user_a) { FactoryBot.create(:user, name: 'ユーザーA', email: 'a@a.com') }
      #ユーザーBを定義
      let(:user_b) { FactoryBot.create(:user, name: 'ユーザーB', email: 'b@b.com') }
      
    before do
      # 施設を作成しておく
      hotspring_a = FactoryBot.create(:hotspring)
      # ユーザーAと紐付けるアソシエーションを作成する（かつuser_aを呼ぶことでユーザーAを作成している）
      FactoryBot.create(:relationship, user: user_a, hotspring: hotspring_a)
      
        visit login_path
        fill_in 'メールアドレス', with: login_user.email
        fill_in 'パスワード', with: login_user.password
        click_button 'ログイン'
    end
    
    context 'ユーザーAがログインしているとき' do
      #login_user = user_aで定義
      let(:login_user) { user_a }
      
      it 'ユーザーAが登録した施設が表示される' do
        # 作成済みの施設名称が画面上に表示されていることを確認'
        expect(page).to have_content 'テスト'
      end
    end
    
    context 'ユーザーBがログインしているとき' do
      #login_user = user_bで定義
      let(:login_user) { user_b }
      
      it 'ユーザーAが登録した施設が表示されない' do
        #ユーザーAが登録した施設名称が画面上に表示されないことを確認
        expect(page).to have_no_content 'テスト'
      end
    end
  end
end