class CategoryIdea
  include ActiveModel::Model
  attr_accessor :category_name, :body

  with_options presence: true do
    validates :category_name
    validates :body
  end

  def save!
    ActiveRecord::Base.transaction do
      category = Category.where(name: category_name).first_or_initialize
      category.save!
      Idea.create!(category_id: category.id, body: body)
    end
  end
end
