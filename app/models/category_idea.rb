class CategoryIdea
  include ActiveModel::Model
  attr_accessor :name, :body

  with_options presence: true do
    validates :name, unique: true
    validates :body
  end

  def save
    category = Category.where(name: category_name).first_or_create
    Idea.create(category_id: category.id, body: body)
  end
end