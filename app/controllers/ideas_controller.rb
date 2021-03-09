class IdeasController < ApplicationController
  
  def index
    if Category.where(name: params[:name]).exists?
      category_id = Category.where(name: params[:name]).ids
      ideas = Idea.where(category_id: category_id)
      data = make_array(ideas)
      render json: {data: data}
    else  
      ideas = Idea.includes(:category)
      data = make_array(ideas)
      render json: {data: data}
    end
  end

  def create
    category_idea = CategoryIdea.new(category_idea_paramns)
    if category_idea.valid?
      @category_idea.save
      render json: {}, status: 201
    else
      render json: {}, status: 422
    end
  end

  private

  def category_idea_paramns
    params.require(:category_idea).permit(:name, :body)
  end

  def make_array(ideas)
    data_array = []
    ideas.each do |idea|
      data_array <<
      {
        id: idea.id,
        category: idea.category.name,
        body: idea.body
      }
    end
    data_array
  end

end