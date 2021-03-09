class IdeasController < ApplicationController
  
  def index
    ideas = Idea.all
    data = []
    ideas.each do |idea|
      data <<
      {
        id: idea.id,
        category: idea.category.name,
        body: idea.body
      }
    end
    render json: {data: data}
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

end