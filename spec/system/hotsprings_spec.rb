require 'rails_helper'

describe 'ユーザー管理機能', type: :system do
  describe '新規ユーザー登録機能' do
    let(:user_success) { FactoryBot.build(:user) }
    let(:user_none) { FactoryBot.build(:user, name: '', email: '', password: '') }

    before do
      visit signup_path
      fill_in 'お名前', with: new_user.name
      fill_in 'メールアドレス', with: new_user.email
      fill_in 'パスワード', with: new_user.password
      fill_in 'パスワード（確認）', with: new_user.password
      click_button '登録する' 
    end
    
    context '新規登録画面で全て入力したとき' do
      let(:new_user) { user_success }
      
      it '正常に登録される' do
        expect(page).to have_selector '.alert-success', text: 'ユーザを登録しました。'
      end
    end
    
    context '新規登録画面で入力しなかったとき' do
      let(:new_user) { user_none }
      
      it '登録に失敗する' do
        expect(page).to have_selector '.alert-danger', text: 'ユーザの登録に失敗しました。'
      end
    end
  end
end
  

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