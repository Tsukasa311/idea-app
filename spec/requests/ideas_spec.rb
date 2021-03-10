require 'rails_helper'

describe IdeasController, type: :request do
  before do
    @idea = FactoryBot.create(:idea)
  end

  describe "GET /ideas" do
    it "indexアクションにリクエストすると、正常にレスポンスが返ってくる" do
      get ideas_path
      expect(response.status).to eq 200
    end
    it 'indexアクションにリクエストすると、レスポンスに投稿済みのアイデアが存在する' do
      get ideas_path
      expect(response.body).to include(@idea.body)
    end
    it 'indexアクションにリクエストすると、レスポンスにカテゴリーの名称が存在する' do
      get ideas_path
      expect(response.body).to include(@idea.category.name)
    end
  end

  describe "POST /create" do
    context '保存できるとき' do
      it '既存のカテゴリーでcreateアクションにリクエストすると、Ideaモデルのカウントが１増え、ステータスコード201を返す' do
        expect{
          params = {category_idea: {category_name: @idea.category.name, body: "new_body"}}
          post ideas_path(params)
          expect(response.status).to eq(201)
        }.to change( Idea, :count ).by(1).and change( Category, :count).by(0)
      end
      it '新規のカテゴリーでcreateアクションにリクエストすると、Ideaモデル、Categoryモデルのカウントがそれぞれ１増え、ステータスコード201を返す' do
        expect{
          params = {category_idea: {category_name: "new_category", body: "new_body"}}
          post ideas_path(params)
          expect(response.status).to eq(201)
        }.to change( Idea, :count ).by(1).and change( Category, :count).by(1)
      end
    end
    
    context '保存できないとき' do
      it 'リクエストに失敗するとステータスコード422を返す(カテゴリーが空）' do
        params = {category_idea: {category_name: "", body: "new_body"}}
        post ideas_path(params)
        expect(response.status).to eq(422)
      end
      it 'リクエストに失敗するとステータスコード422を返す（本文が空）' do
        params = {category_idea: {category_name: "new_category", body: ""}}
        post ideas_path(params)
        expect(response.status).to eq(422)
      end
    end
  end
end