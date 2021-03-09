class IdeasController < ApplicationController
  def index
    if Category.where(name: 'aaa').exists?
      category_id = Category.where(name: params[:category_name]).ids
      ideas = Idea.where(category_id: category_id)
      data = make_array(ideas)
      render json: { data: data }
    elsif params[:category_name].blank?
      ideas = Idea.includes(:category)
      data = make_array(ideas)
      render json: { data: data }
    else
      render json: {}, status: 404
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
    params.require(:category_idea).permit(:category_name, :body)
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
