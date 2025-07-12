class Api::V1::CategoriesController < ApplicationController
  before_action :set_category, only: [:update, :destroy]
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

  def update
    if @category.update(category_params)
      render json: @category
    else
      render json: { errors: @category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def set_category
    @category = current_user.categories.find_by(id: params[:id])
  end

  def destroy
    @category.destroy
    head :no_content
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
