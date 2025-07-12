class Api::V1::CategoriesController < ApplicationController
  def index
    render json: current_user.categories
  end

  def create
    category = current_user.categories.build(category_params)
    if category.save
      render json: category, status: :created
    else
      render json: { errors:category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
