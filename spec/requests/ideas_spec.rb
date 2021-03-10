require 'rails_helper'
RSpec::Matchers.define_negated_matcher :exclude, :include

describe IdeasController, type: :request do
  before do
    @idea = FactoryBot.create(:idea)
    @another_idea = FactoryBot.create(:idea)
  end

  describe 'GET #index' do
    context 'アイデアが取得できるとき' do
      it 'category_nameを指定してリクエストすると、該当するcategoryのアイデアを返す' do
        params = { category_name: @idea.category.name }
        get ideas_path(params)
        expect(response.body).to include(@idea.category.name).and exclude(@another_idea.category.name)
      end
      it 'category_nameを指定せずにリクエストすると、全てのアイデアを返す' do
        params = { category_name: nil }
        get ideas_path(params)
        expect(response.body).to include(@idea.body).and include(@another_idea.body)
      end
    end
    context 'アイデアが取得できないとき' do
      it '登録されていないカテゴリーをリクエストすると、ステータスコード404を返す' do
        get ideas_path(category_name: 'aaa')
        expect(response.status).to eq(404)
      end
    end
  end

  describe 'POST #create' do
    context '保存できるとき' do
      it '既存のカテゴリーでcreateアクションにリクエストすると、Ideaモデルのカウントが１増え、ステータスコード201を返す' do
        expect {
          params = { category_idea: { category_name: @idea.category.name, body: 'new_body' } }
          post ideas_path(params)
          expect(response.status).to eq(201)
        }.to change(Idea, :count).by(1).and change(Category, :count).by(0)
      end
      it '新規のカテゴリーでcreateアクションにリクエストすると、Ideaモデル、Categoryモデルのカウントがそれぞれ１増え、ステータスコード201を返す' do
        expect {
          params = { category_idea: { category_name: 'new_category', body: 'new_body' } }
          post ideas_path(params)
          expect(response.status).to eq(201)
        }.to change(Idea, :count).by(1).and change(Category, :count).by(1)
      end
    end
    context '保存できないとき' do
      it 'リクエストに失敗するとステータスコード422を返す(カテゴリーが空）' do
        params = { category_idea: { category_name: '', body: 'new_body' } }
        post ideas_path(params)
        expect(response.status).to eq(422)
      end
      it 'リクエストに失敗するとステータスコード422を返す（本文が空）' do
        params = { category_idea: { category_name: 'new_category', body: '' } }
        post ideas_path(params)
        expect(response.status).to eq(422)
      end
    end
  end
end
