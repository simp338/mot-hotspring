require 'rails_helper'

describe '施設管理機能', type: :system do
  let(:user_a) { FactoryBot.create(:user, name: 'ユーザーA', email: 'a@a.com') }
  let(:user_b) { FactoryBot.create(:user, name: 'ユーザーB', email: 'b@b.com') }
  let(:hotspring_a) { FactoryBot.create(:hotspring) }
  let!(:relationship_a) { FactoryBot.create(:relationship, user: user_a, hotspring:hotspring_a) }
  
  shared_examples_for 'ユーザーAが登録した施設が表示される' do
    it { expect(page).to have_content 'カーブドッチ　ヴィネスパ' }
  end
      
  before do
    visit login_path
    fill_in 'メールアドレス', with: login_user.email
    fill_in 'パスワード', with: login_user.password
    click_button 'ログイン'
  end  
  
  describe '一覧表示機能' do
    context 'ユーザーAがログインしているとき' do
      let(:login_user) { user_a }
    
      it_behaves_like 'ユーザーAが登録した施設が表示される'
    end
    
    context 'ユーザーBがログインしているとき' do
      let(:login_user) { user_b }
      
      it 'ユーザーAが登録した施設が表示されない' do
        expect(page).to have_no_content 'テスト'
      end
    end
  end
  
  describe '詳細表示機能' do
    context 'ユーザーAがログインしているとき' do
      let(:login_user) { user_a }
      
      before do
        visit "/hotspring/#{hotspring_a.code}"
      end
      
      it_behaves_like 'ユーザーAが登録した施設が表示される'
    end
  end
end