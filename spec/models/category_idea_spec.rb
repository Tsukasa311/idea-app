require 'rails_helper'

RSpec.describe CategoryIdea, type: :model do
  before do
    @idea = FactoryBot.build(:idea)
    @category = FactoryBot.build(:category)
  end

  context 'アイデアを保存できるとき' do
    it 'リクエストに「カテゴリー」と「本文」が含まれているとき' do
      expect(@idea).to be_valid
    end
  end

  context 'アイデアを保存できないとき' do
    it 'リクエストに「カテゴリー」が含まれていないとき' do
      @category.name = nil
      @category.valid?
      expect(@category.errors.full_messages).to include("Name can't be blank")
    end
    it 'リクエストに「本文」が含まれていないとき' do
      @idea.body = nil
      @idea.valid?
      expect(@idea.errors.full_messages).to include("Body can't be blank")
    end
    it '「カテゴリー」に一意性がないとき' do
      @category.save
      anoter_category = FactoryBot.build(:category)
      anoter_category.name = @category.name
      anoter_category.valid?
      expect(anoter_category.errors.full_messages).to include('Name has already been taken')
    end
  end
end
