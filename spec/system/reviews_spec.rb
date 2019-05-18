require 'rails_helper'

describe 'レビュー管理機能', type: :system do
  let(:user_a) { FactoryBot.create(:user, name: 'テストユーザーA') }
  let(:user_b) { FactoryBot.create(:user, name: 'テストユーザーB') }
  let(:hotspring_a) { FactoryBot.create(:hotspring,
    name: 'ホテルモントレエーデルホフ札幌 ',
    code: 7523,
    url: 'https://hotel.travel.rakuten.co.jp/hinfo/?f_no=7523',
    image_url:'https://img.travel.rakuten.co.jp/share/HOTEL/7523/7523.jpg' ,
    ) }
  let!(:review_a) { FactoryBot.create(:review, user_id: user_a.id, hotspring_id: hotspring_a.id) }

  describe 'レビュー管理機能（ログインなし）' do
    context 'レビュー一覧にアクセスしたとき' do
      before do
        visit "hotspring/#{hotspring_a.code}/reviews"
      end
      it 'ユーザーAが投稿したレビューが表示される' do
        expect(page).to have_content review_a.title
        expect(page).to have_content review_a.comment
      end
    end

    context 'レビュー新規作成画面にアクセスしたとき' do
      before do
        visit "hotspring/#{hotspring_a.code}/reviews/new"
      end
      it 'ログイン画面に遷移する' do
        expect(page).to have_selector '.alert-warning', text: 'ログインが必要です。'
      end
    end

    context 'レビュー詳細にアクセスしたとき' do
      before do
        visit "hotspring/#{hotspring_a.code}/reviews/#{review_a.id}/"
      end
      it '編集・削除ボタンが表示されない' do
        expect(page).not_to have_selector '.btn', text: '編集'
        expect(page).not_to have_selector '.btn', text: '削除'
      end
    end
  end

  describe 'レビュー管理機能（ログインあり）' do
    before do
      visit login_path
      fill_in 'メールアドレス', with: login_user.email
      fill_in 'パスワード', with: login_user.password
      click_button 'ログイン'
    end
    
    describe 'レビュー投稿機能' do
      context 'ユーザーAがログインしているとき' do
        let(:login_user) { user_a }
        before do
          visit "hotspring/#{hotspring_a.code}/reviews"
        end
      
        it 'ユーザーAが投稿したレビューが表示される' do
          expect(page).to have_content review_a.title
          expect(page).to have_content review_a.comment
        end
      end
      
      context 'ユーザーBがログインしているとき' do
        let(:login_user) { user_b }
        before do
          visit "hotspring/#{hotspring_a.code}/reviews"
        end
        
        it 'ユーザーAが投稿したレビューが表示される' do
          expect(page).to have_content review_a.title
          expect(page).to have_content review_a.comment
        end
      end
    end
    
    describe 'レビュー編集機能' do
      context 'ユーザーAがログインしているとき' do
        let(:login_user) { user_a }
        before do
          visit "hotspring/#{hotspring_a.code}/reviews/#{review_a.id}"
        end
        it '編集・削除ボタンが表示される' do
          expect(page).to have_selector '.btn', text: '編集'
          expect(page).to have_selector '.btn', text: '削除'
        end
      end
      
      context 'ユーザーBがログインしているとき' do
        let(:login_user) { user_b }
        before do
          visit "hotspring/#{hotspring_a.code}/reviews/#{review_a.id}/"
        end
        it '編集・削除ボタンが表示されない' do
          expect(page).not_to have_selector '.btn', text: '編集'
          expect(page).not_to have_selector '.btn', text: '削除'
        end
      end
  
      context 'ユーザーAがログインしているとき'
        let(:login_user) { user_a }
        before do
          visit "hotspring/#{hotspring_a.code}/reviews/#{review_a.id}/edit"
        end
        it '編集画面が表示される' do
          expect(page).to have_content 'レビューを編集する'
        end
        
      context 'ユーザーBがログインしているとき' do
        let(:login_user) { user_b }
        before do
          visit "hotspring/#{hotspring_a.code}/reviews/#{review_a.id}/edit"
        end
        it '不正なアクセスとして拒否される' do
          expect(page).to have_selector '.alert-danger', text: '不正なアクセス'
        end
      end
    end
  end
end