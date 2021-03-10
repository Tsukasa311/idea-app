require 'rails_helper'

RSpec.describe CategoryIdea, type: :model do
  before do
    @idea = FactoryBot.build(:category_idea)
  end

  context 'アイデアを保存できるとき' do
    it 'リクエストに「カテゴリー」と「本文」が含まれているとき' do
      expect(@idea).to be_valid
    end
  end

  context 'アイデアを保存できないとき' do
    it 'リクエストに「カテゴリー」が含まれていないとき' do
      @idea.name = nil
      @idea.valid?
      expect(@idea.errors.full_messages).to include("Name can't be blank")
    end
    it 'リクエストに「本文」が含まれていないとき' do
      @idea.body = nil
      @idea.valid?
      expect(@idea.errors.full_messages).to include("Body can't be blank")
    end
    it '「カテゴリー」に一意性がないとき' do
      category_1 = FactoryBot.create(:category)
      category_2 = FactoryBot.build(:category)
      category_2.name = category_1.name
      category_2.valid?
      expect(category_2.errors.full_messages).to include('Name has already been taken')
    end
  end
end
