require 'rails_helper'

describe IdeasController, type: :request do
  before do
    @idea = FactoryBot.create(:idea)
  end

  describe 'GET #index' do
    it 'category_nameを指定してリクエストすると、該当するcategoryのアイデアを返す' do
      params = { category_name: @idea.category.name }
      get ideas_path(params)
      expect(response.body).to include(@idea.category.name).and include(@idea.body)
    end
    it 'category_nameを指定せずにリクエストすると、全てのアイデアを返す' do
      another_idea = FactoryBot.create(:idea)
      params = { category_name: nil }
      get ideas_path(params)
      expect(response.body).to include(@idea.body).and include(another_idea.body)
    end
    it '登録されていないカテゴリーをリクエストすると、ステータスコード404を返す' do
      get ideas_path(category_name: 'aaa')
      expect(response.status).to eq(404)
    end
  end

  describe 'POST #create' do
    context '保存できるとき' do
      it '既存のカテゴリーでcreateアクションにリクエストすると、Ideaモデルのカウントが１増え、ステータスコード201を返す' do
        expect do
          params = { category_idea: { category_name: @idea.category.name, body: 'new_body' } }
          post ideas_path(params)
          expect(response.status).to eq(201)
        end.to change(Idea, :count).by(1).and change(Category, :count).by(0)
      end
      it '新規のカテゴリーでcreateアクションにリクエストすると、Ideaモデル、Categoryモデルのカウントがそれぞれ１増え、ステータスコード201を返す' do
        expect do
          params = { category_idea: { category_name: 'new_category', body: 'new_body' } }
          post ideas_path(params)
          expect(response.status).to eq(201)
        end.to change(Idea, :count).by(1).and change(Category, :count).by(1)
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
